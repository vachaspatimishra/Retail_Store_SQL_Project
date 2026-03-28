select * from customers;

select * from products;

select * from orders;

select * from order_items;

select * from payments;

select * from product_reviews;

-- Level 1: Basics
-- 1. Retrieve customer names and emails for email marketing
SELECT name, email FROM customers;

-- 2. View complete product catalog with all available details
SELECT * FROM products;

-- 3. List all unique product categories
SELECT DISTINCT category FROM products;

-- 4. Show all products priced above ₹1,000
SELECT name FROM products WHERE price > 1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000)
SELECT name FROM products WHERE price >=2000 and price <=5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list)
SELECT * FROM customers WHERE customer_id IN (1, 2, 3, 4, 5, 6);

-- 7. Identify customers whose names start with the letter ‘A’
SELECT * FROM customers WHERE name LIKE "A%";

-- 8. List electronics products priced under ₹3,000
SELECT name FROM products WHERE category = "Electronics" and price <=3000;

-- 9. Display product names and prices in descending order of price
SELECT name, price FROM products ORDER BY price desc;

-- 10. Display product names and prices, sorted by price and then by name
SELECT name, price FROM products ORDER BY price, name;


-- Level 2: Filtering and Formatting
-- 1. Retrieve orders where customer information is missing (possibly due to data migration or deletion)
SELECT * FROM customers WHERE customer_id IS NULL;

-- 2. Display customer names and emails using column aliases for frontend readability
SELECT name AS customer_name, email AS customer_email FROM customers;

-- 3.  Calculate total value per item ordered by multyplying quantity and item price
SELECT *, quantity*item_price  AS total_value FROM order_items;

-- 4. Combine customer name and phone number in a single column
SELECT CONCAT(name, "-", phone) AS customer_directory FROM customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting
SELECT *, DATE(order_date) AS date FROM orders;

-- 6. List products that do not have any stock left
SELECT * FROM products WHERE stock_quantity = 0;


-- Level 3: Aggregations
-- 1. Count the total number of orders placed
SELECT COUNT(order_id) AS order_count FROM orders;

-- 2. Calculate the total revenue collected from all orders
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- 3. Calculate the average order value
SELECT AVG(total_amount) AS avg_order_value FROM orders;

-- 4. Count the number of customers who have placed at least one order
SELECT COUNT(DISTINCT customer_id) FROM orders;

-- 5. Find the number of orders placed by each customer
SELECT customer_id, COUNT(order_id) FROM orders GROUP BY customer_id;

-- 6. Find total sales amount made by each customer
SELECT customer_id, SUM(total_amount) FROM orders GROUP BY customer_id;

-- 7. List the number of products sold per category
SELECT category, COUNT(product_id) FROM products GROUP BY category;

-- 8. Find the average item price per category
SELECT category, AVG(price) FROM products GROUP BY category;

-- 9. Show number of orders placed per day
SELECT DATE(order_date), COUNT(order_id) FROM orders GROUP BY DATE(order_date);

-- 10. List total payments received per payment method
SELECT method, SUM(amount_paid) FROM payments GROUP BY method;

SELECT method, concat("₹ ",SUM(amount_paid)) FROM payments GROUP BY method;


-- Level 4: Multi-Table Queries (JOINS)
-- 1. Retrieve order details along with the customer name (INNER JOIN)
SELECT c.name, o.*
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items)
SELECT distinct p.name
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id;

-- 3. List all orders with their payment method (INNER JOIN)
SELECT o.order_id, p.method
FROM orders o
JOIN payments p
ON o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN)
SELECT c.name, o.*
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN)
SELECT p.name, oi.quantity
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id;

-- 6. List all payments including those with no matching orders (RIGHT JOIN)
SELECT p.*, o.order_id
FROM orders o
RIGHT JOIN payments p
ON o.order_id = p.order_id;

-- 7. Combine data from three tables: customer, order, and payment
SELECT c.*, o.*, p.*
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id;


-- Level 5: Subqueries (Inner Queries)
-- 1. List all products priced above the average product price
SELECT * FROM products WHERE price >
(SELECT AVG(price) FROM products);

-- 2. Find customers who have placed at least one order  
SELECT customer_id, name FROM customers                                        -- (three methods- join, in, exists)
WHERE customer_id IN (SELECT customer_id FROM orders);

-- Method 2 (using EXISTS) (Advantage- stops searching after one value found, if 1 is written instead of customer_id)
SELECT c.customer_id, c.name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);     -- (1 <-> customer_id)

-- 3. Show orders whose total amount is above the average for that customer
SELECT * FROM
(SELECT *, AVG(total_amount) OVER(PARTITION BY customer_id) AS avg_amount FROM orders) t
WHERE total_amount > avg_amount;

-- 4. Display customers who haven’t placed any orders
SELECT name FROM customers WHERE customer_id NOT IN
(SELECT customer_id FROM orders);

-- 5. Show products that were never ordered
SELECT name FROM products WHERE product_id NOT IN
(SELECT product_id FROM order_items);

-- 6. Show highest value order per customer
SELECT * 
FROM (SELECT customer_id, max(total_amount) AS max_amount FROM orders GROUP BY customer_id) t;

-- Method 2
SELECT customer_id, MAX(total_amount) FROM orders GROUP BY customer_id;

-- 7. Highest Order Per Customer (Including Names)
SELECT c.customer_id, c.name, t.max_amount
FROM customers c
JOIN (SELECT customer_id, MAX(total_amount) AS max_amount FROM orders GROUP BY customer_id) t
ON c.customer_id = t.customer_id;


-- Level 6: Set Operations
-- 1. List all customers who have either placed an order or written a product review
SELECT customer_id FROM orders
UNION
SELECT customer_id FROM product_reviews;

-- 2. List all customers who have placed an order as well as reviewed a product
SELECT DISTINCT customer_id FROM orders
WHERE customer_id IN
(SELECT customer_id FROM product_reviews);

-- using join
select distinct o.customer_id
from orders o 
join product_reviews pr
on o.customer_id = pr.customer_id;















