CREATE DATABASE LMS
GO
USE LMS
GO

/*
  TABLE 1 - LIBRARY_BRANCH
  TABLE 1 - LIBRARY_BRANCH
  TABLE 1 - LIBRARY_BRANCH
  TABLE 1 - LIBRARY_BRANCH
  TABLE 1 - LIBRARY_BRANCH
  TABLE 1 - Starting point.  pk_LIBRARY_BRANCH.BranchID is needed by 2 tables as fk
*/

CREATE TABLE LIBRARY_BRANCH (
	BranchID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	BranchName VARCHAR(50) NOT NULL,
	Address VARCHAR(100) NOT NULL
);
DROP TABLE LIBRARY_BRANCH

/*
  TABLE 2 - PUBLISHER
  TABLE 2 - PUBLISHER
  TABLE 2 - PUBLISHER
  TABLE 2 - PUBLISHER
  TABLE 2 - PUBLISHER
  TABLE 2 - fk_BOOKS.PublisherName needs a fk for pk_PUBLISHER.PublisherName)
*/

CREATE TABLE PUBLISHER (
    id INT,
    PublisherName VARCHAR (50),
	Address VARCHAR (50),
	Phone VARCHAR (15)
);
/*
  -- 2a) Execute ALTER lines one at a time BEFORE any other tables are created
  -- 2a) Execute ALTER lines one at a time BEFORE any other tables are created
  -- 2a) Execute ALTER lines one at a time BEFORE any other tables are created
*/
ALTER TABLE PUBLISHER ALTER COLUMN PublisherName varchar(50) NOT NULL;
ALTER TABLE PUBLISHER ADD CONSTRAINT pk_PublisherName PRIMARY KEY(PublisherName);
DROP TABLE PUBLISHER

/*
  TABLE 3 - BOOKS
  TABLE 3 - BOOKS
  TABLE 3 - BOOKS
  TABLE 3 - BOOKS
  TABLE 3 - BOOKS
  TABLE 3 - pk_BOOKS.BookID needed by fk_BOOK_AUTHORS.BookID and fk_BOOK_LOANS.BookID
*/

CREATE TABLE BOOKS (
    BookID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	Title VARCHAR (50),
    PublisherName VARCHAR(50) NOT NULL
);
/*
  3a) BOOKS.PublisherName needs to be a fk to pk_PUBLISHER.PublisherName
  3a) BOOKS.PublisherName needs to be a fk to pk_PUBLISHER.PublisherName
  3a) BOOKS.PublisherName needs to be a fk to pk_PUBLISHER.PublisherName
*/
ALTER TABLE BOOKS ADD CONSTRAINT fk_PublisherName FOREIGN KEY(PublisherName) REFERENCES PUBLISHER(PublisherName);
DROP TABLE BOOKS

/*
  TABLE 4 - COOK_COPIES
  TABLE 4 - COOK_COPIES
  TABLE 4 - COOK_COPIES
  TABLE 4 - COOK_COPIES
  TABLE 4 - COOK_COPIES
  TABLE 4 - Make fk to BOOKS.BookID and LIBRARY_BRANCH.BranchID

-------  CHECK  -------
-------  CHECK  -------
-------  CHECK  -------
-------  CHECK  -------

  -- Doesn't look like there's foreign keys for BookID or BranchID, so these should work as is... RUN IT BITCH

*/

CREATE TABLE BOOK_COPIES (
    BookID INT NOT NULL CONSTRAINT fk_BookID FOREIGN KEY REFERENCES Books(BookID) ON UPDATE CASCADE ON DELETE CASCADE,
	BranchID INT NOT NULL CONSTRAINT fk_BranchID FOREIGN KEY REFERENCES LIBRARY_BRANCH(BranchID) ON UPDATE CASCADE ON DELETE CASCADE,
    Number_Of_Copies VARCHAR (3)
);
DROP TABLE BOOK_COPIES
USE LMS
sp_help BOOK_COPIES;
ALTER TABLE BOOK_COPIES ALTER COLUMN Number_Of_Copies VARCHAR (4);
sp_help BOOK_COPIES;

/*
  TABLE 5 - BOOK_AUTHORS
  TABLE 5 - BOOK_AUTHORS
  TABLE 5 - BOOK_AUTHORS
  TABLE 5 - BOOK_AUTHORS
  TABLE 5 - BOOK_AUTHORS
  TABLE 5 - fk_BookID exists, so name it BookID2
*/

CREATE TABLE BOOK_AUTHORS (
    BookID INT NOT NULL CONSTRAINT fk_BookID2 FOREIGN KEY REFERENCES BOOKS(BookID) ON UPDATE CASCADE ON DELETE CASCADE,
	AuthorName VARCHAR(50)
);
DROP TABLE BOOK_AUTHORS

/*
  TABLE 6 - BORROWER
  TABLE 6 - BORROWER
  TABLE 6 - BORROWER
  TABLE 6 - BORROWER
  TABLE 6 - BORROWER
  TABLE 6 - This should be good-to-go as is...
*/

CREATE TABLE BORROWER (
    CardNo INT PRIMARY KEY NOT NULL IDENTITY (1,1),
	Name VARCHAR (50),
    Address VARCHAR (50),
	Phone VARCHAR (15)
);
DROP TABLE BORROWER

/*
  TABLE 7 - BOOK_LOANS
  TABLE 7 - BOOK_LOANS
  TABLE 7 - BOOK_LOANS
  TABLE 7 - BOOK_LOANS
  TABLE 7 - BOOK_LOANS
  TABLE 7 - Need fk's for BookID, BranchID, and CardNo.  BookID and BranchID are already made, so number them 3 and 2 respectively
*/

CREATE TABLE BOOK_LOANS (
    BookID INT NOT NULL CONSTRAINT fk_BookID3 FOREIGN KEY REFERENCES BOOKS(BookID) ON UPDATE CASCADE ON DELETE CASCADE,
	BranchID INT NOT NULL CONSTRAINT fk_BranchID2 FOREIGN KEY REFERENCES LIBRARY_BRANCH(BranchID) ON UPDATE CASCADE ON DELETE CASCADE,
	CardNo INT NOT NULL CONSTRAINT fk_CardNo FOREIGN KEY REFERENCES BORROWER(CardNo) ON UPDATE CASCADE ON DELETE CASCADE,
	DateOut DATE NOT NULL,
	DateDue DATE NOT NULL
);
DROP TABLE BOOK_LOANS


SELECT BranchID as 'LIBRARY_BRANCH.Branch ID', BranchName as 'Branch Name', Address from LIBRARY_BRANCH
SELECT PublisherName as 'PUBLISHER.Name', Address, Phone from PUBLISHER ORDER BY ID
SELECT BookID as 'BOOKS.Book ID', Title, PublisherName as 'Publisher Name' from BOOKS
SELECT BookID as 'BOOK_COPIES.Book ID', BranchID, Number_Of_Copies as '#ofCopies' from BOOK_COPIES
SELECT BookID as 'BOOK_AUTHORS.Book ID', AuthorName as 'Author' from BOOK_AUTHORS
SELECT CardNo as 'BORROWER.Card #', Name, Address, Phone from BORROWER
SELECT BookID as 'BOOK_LOANS.Book ID', BranchID, CardNo, DateOut, DateDue from BOOK_LOANS

USE LMS
GO

INSERT INTO LIBRARY_BRANCH (BranchName, Address) VALUES
    ('Sharpstown', 'Sharpstown Rd.'),
	('Jacoby', 'Jacoby Lane'),
	('Central','Central Ave.'),
	('Broadway','Broadway Ave.')
;
Select * from LIBRARY_BRANCH

INSERT INTO PUBLISHER (PublisherName, Address, Phone) VALUES
    ('Tribal Books','Tribal Way','800-GO-Tribe'),
	('Jacoby Publishing','Jacoby Lane','800-GO-Jacob'),
	('Scribner','Fifth Ave, NY', '212-698-7541'),
	('Doubleday','Broadway, NY','866-250-3166'), 
	('Fifth','Fifth Ave','555-555-5555'),
	('Sixth','Sixth Ave','666-666-6666'),
	('Seventh','Seventh Ave','777-777-7777'),
	('Eighth','Eighth Ave','888-888-8888'),
	('Ninth','Ninth Ave','999-999-9999'),
	('Tenth','Tenth Ave','10-1010-1010')
;
UPDATE PUBLISHER Set id =1 where publishername = 'Tribal Books';
UPDATE PUBLISHER Set id =2 where publishername = 'Jacoby Publishing';
UPDATE PUBLISHER Set id =3 where publishername = 'Scribner';
UPDATE PUBLISHER Set id =4 where publishername = 'Doubleday';
UPDATE PUBLISHER Set id =5 where publishername = 'Fifth';
UPDATE PUBLISHER Set id =6 where publishername = 'Sixth';
UPDATE PUBLISHER Set id =7 where publishername = 'Seventh';
UPDATE PUBLISHER Set id =8 where publishername = 'Eighth';
UPDATE PUBLISHER Set id =9 where publishername = 'Ninth';
UPDATE PUBLISHER Set id =10 where publishername = 'Tenth';
Select * from PUBLISHER order by ID


INSERT INTO BOOKS (Title, PublisherName) VALUES 
     ('The Lost Tribe', 'Tribal Books'),
     ('The Lost Tribe 2', 'Tribal Books'),
     ('The Lost Tribe 3', 'Tribal Books'),
     ('The Lost Tribe 4', 'Tribal Books'),
     ('The Lost Tribe 5', 'Tribal Books'),
     ('The Lost Tribe 6', 'Tribal Books'),
     ('The Lost Tribe 7', 'Tribal Books'),
     ('The Lost Tribe 8', 'Tribal Books'),
     ('The Lost Tribe 9', 'Tribal Books'),
     ('The Lost Tribe 10', 'Tribal Books'),
	 ('Book 11', 'Jacoby Publishing'),
	 ('Book 12', 'Jacoby Publishing'),
	 ('Book 13', 'Jacoby Publishing'),
	 ('Book 14', 'Jacoby Publishing'),
	 ('Book 15', 'Jacoby Publishing'),
	 ('Book 16', 'Jacoby Publishing'),
	 ('Book 17', 'Jacoby Publishing'),
	 ('Book 18', 'Jacoby Publishing'),
	 ('Book 19', 'Jacoby Publishing'),
	 ('Book 20', 'Jacoby Publishing'),
	 ('Doctor Sleep','Scribner'),
	 ('IT','Scribner'),
	 ('Pet Sematary','Scribner'),
	 ('The Mist','Scribner'),
	 ('Needful Things','Scribner'),
	 ('Cujo','Scribner'),
	 ('Misery','Scribner'),
	 ('The Running Man','Scribner'),
	 ('The Dead Zone','Scribner'),
	 ('Christine','Scribner'),
	 ('The Stand','Doubleday'),
	 ('Carrie','Doubleday'),
	 ('The Shining','Doubleday'),
	 ('Salem''s Lot','Doubleday'),
	 ('A Time to Kill','Doubleday'),
	 ('The Firm','Doubleday'),
	 ('The Client','Doubleday'),
	 ('The Chamber','Doubleday'),
	 ('The Pelican Brief','Doubleday'),
	 ('The Rainmaker','Doubleday'),
	 ('My Fifth','Fifth'),
	 ('My Sixth','Sixth'),
	 ('My Seventh','Seventh'),
	 ('My Eighth','Eighth'),
	 ('My Ninth','Ninth'),
	 ('My Tenth','Tenth')
;
Select * from Books

INSERT INTO BOOK_COPIES (BookID, BranchID, Number_Of_Copies) VALUES
    ('1', '1', '2'),
	('2', '1', '2'),
	('3', '1', '2'),
	('4', '1', '2'),
	('5', '1', '2'),
	('6', '1', '2'),
	('7', '1', '2'),
	('8', '1', '2'),
	('9', '1', '2'),
	('10', '1', '2'),
	('11', '2', '2'),
	('12', '2', '2'),
	('13', '2', '2'),
	('14', '2', '2'),
	('15', '2', '2'),
	('16', '2', '2'),
	('17', '2', '2'),
	('18', '2', '2'),
	('19', '2', '2'),
	('20', '2', '2'),
	('21', '3', '1000'),
	('22', '3', '1000'),
	('23', '3', '1000'),
	('24', '3', '1000'),
	('25', '3', '1000'),
	('26', '3', '1000'),
	('27', '3', '1000'),
	('28', '3', '1000'),
	('29', '3', '1000'),
	('30', '3', '1000'),
	('31', '4', '5000'),
	('32', '4', '5000'),
	('33', '4', '5000'),
	('34', '4', '5000'),
	('35', '4', '5000'),
	('36', '4', '5000'),
	('37', '4', '5000'),
	('38', '4', '5000'),
	('39', '4', '5000'),
	('40', '4', '5000')
;
Select * from BOOK_COPIES

INSERT INTO BOOK_AUTHORS (BookID, AuthorName) VALUES
    ('1', 'Joe Tribe'),
    ('2', 'Joe Tribe'),
    ('3', 'Joe Tribe'),
    ('4', 'Joe Tribe'),
    ('5', 'Joe Tribe'),
    ('6', 'Joe Tribe'),
    ('7', 'Joe Tribe'),
    ('8', 'Joe Tribe'),
    ('9', 'Joe Tribe'),
    ('10', 'Joe Tribe'),
	('11', 'Mike Jacoby'),
	('12', 'Mike Jacoby'),
	('13', 'Mike Jacoby'),
	('14', 'Mike Jacoby'),
	('15', 'Mike Jacoby'),
	('16', 'Mike Jacoby'),
	('17', 'Mike Jacoby'),
	('18', 'Mike Jacoby'),
	('19', 'Mike Jacoby'),
	('20', 'Mike Jacoby'),
	('21', 'Stephen King'),
	('22', 'Stephen King'),
	('23', 'Stephen King'),
	('24', 'Stephen King'),
	('25', 'Stephen King'),
	('26', 'Stephen King'),
	('27', 'Stephen King'),
	('28', 'Stephen King'),
	('29', 'Stephen King'),
	('30', 'Stephen King'),
	('31', 'Stephen King'),
	('32', 'Stephen King'),
	('33', 'Stephen King'),
	('34', 'Stephen King'),
	('35', 'John Grisham'),
	('36', 'John Grisham'),
	('37', 'John Grisham'),
	('38', 'John Grisham'),
	('39', 'John Grisham'),
	('40', 'John Grisham'),
	('41', 'Joe Fifthauthor'),
	('42', 'Joe Sixthauthor'),
	('43', 'Joe Seventhauthor'),
	('44', 'Joe Eighthauthor'),
	('45', 'Joe Ninthauthor'),
	('46', 'Joe Tenthauthor')
;

INSERT INTO BORROWER (Name, Address, Phone) VALUES
    ('Angela', '1 Way', '1234567890'),
	('Brad', '2 Way', '2345678901'),
	('Charlie', '3 Way', '3456789102'),
	('Doug', '4 Way', '4567890123'),
	('Edward', '5 Way', '5678901234'),
	('Frank', '6 Way', '6789012345'),
	('George', '7 Way', '7890123456'),
	('Harold', '8 Way', '8901234567'),
	('Isabella', '9 Way', '9012345678'),
    ('Jake', '10 Way', '0123456789')
;
select * from borrower
select * from book_loans

INSERT INTO BOOK_LOANS (BookID, BranchID, CardNo, DateOut, DateDue) VALUES
    ('21', '3', '1', '2020-01-01', '2020-03-31'),
    ('22', '3', '1', '2020-01-01', '2020-03-31'),
    ('23', '3', '1', '2020-01-01', '2020-03-31'),
    ('24', '3', '1', '2020-01-01', '2020-03-31'),
    ('25', '3', '1', '2020-01-01', '2020-03-31'),
    ('26', '3', '1', '2020-01-01', '2020-03-31'),
    ('27', '3', '1', '2020-01-01', '2020-03-31'),
    ('28', '3', '1', '2020-01-01', '2020-03-31'),
    ('29', '3', '1', '2020-01-01', '2020-03-31'),
    ('30', '3', '1', '2020-01-01', '2020-03-31'),
	('31', '3', '1', '2020-01-01', '2020-03-31'),
	('32', '3', '1', '2020-01-01', '2020-03-31'),
	('33', '3', '1', '2020-01-01', '2020-03-31'),
	('34', '3', '1', '2020-01-01', '2020-03-31'),
	('35', '4', '2', '2020-01-10', '2020-04-10'),
	('36', '4', '2', '2020-01-10', '2020-04-10'),
	('37', '4', '2', '2020-01-10', '2020-04-10'),
	('38', '4', '2', '2020-01-10', '2020-04-10'),
	('39', '4', '2', '2020-01-10', '2020-04-10'),
	('40', '4', '2', '2020-01-10', '2020-04-10'),
	('1', '1', '3', '2020-01-01', '2020-03-31'),
	('1', '1', '4', '2020-01-01', '2020-03-31'),
	('25', '3', '4', '2020-02-01', '2020-04-30'),
    ('26', '3', '4', '2020-02-01', '2020-04-30'),
    ('27', '3', '4', '2020-02-01', '2020-04-30'),
    ('28', '3', '5', '2020-02-01', '2020-04-30'),
    ('29', '3', '5', '2020-02-01', '2020-04-30'),
    ('30', '3', '5', '2020-02-01', '2020-04-30'),
	('31', '4', '6', '2020-01-15', '2020-04-15'),
	('33', '4', '6', '2020-01-15', '2020-04-15'),
	('2', '1', '7', '2020-01-07', '2020-04-07'),
	('3', '1', '7', '2020-01-07', '2020-04-07'),
	('4', '1', '7', '2020-01-07', '2020-04-07'),
	('5', '1', '7', '2020-01-07', '2020-04-07'),
	('6', '1', '7', '2020-01-07', '2020-04-07'),
	('7', '1', '7', '2020-01-07', '2020-04-07'),
	('8', '1', '7', '2020-01-07', '2020-04-07'),
	('9', '1', '7', '2020-01-07', '2020-04-07'),
	('10', '1', '7', '2020-01-07', '2020-04-07'),
	('2', '1', '8', '2020-01-14', '2020-04-14'),
	('3', '1', '8', '2020-01-14', '2020-04-14'),
	('4', '1', '8', '2020-01-14', '2020-04-14'),
	('5', '1', '8', '2020-01-14', '2020-04-14'),
	('6', '1', '8', '2020-01-14', '2020-04-14'),
	('7', '1', '8', '2020-01-14', '2020-04-14'),
	('8', '1', '8', '2020-01-14', '2020-04-14'),
	('9', '1', '8', '2020-01-14', '2020-04-14'),
	('10', '1', '8', '2020-01-14', '2020-04-14'),
	('11', '2', '9', '2020-02-01', '2020-04-30'),
	('12', '2', '9', '2020-02-01', '2020-04-30'),
	('13', '2', '9', '2020-02-01', '2020-04-30'),
	('14', '2', '9', '2020-02-01', '2020-04-30'),
	('15', '2', '9', '2020-02-01', '2020-04-30'),
	('16', '2', '9', '2020-02-01', '2020-04-30'),
	('17', '2', '9', '2020-02-01', '2020-04-30'),
	('18', '2', '9', '2020-02-01', '2020-04-30'),
	('19', '2', '9', '2020-02-01', '2020-04-30'),
	('20', '2', '9', '2020-02-01', '2020-04-30')
;

SELECT BranchID as 'LIBRARY_BRANCH.Branch ID', BranchName as 'Branch Name', Address from LIBRARY_BRANCH
SELECT PublisherName as 'PUBLISHER.Name', Address, Phone from PUBLISHER ORDER BY ID
SELECT BookID as 'BOOKS.Book ID', Title, PublisherName as 'Publisher Name' from BOOKS
SELECT BookID as 'BOOK_COPIES.Book ID', BranchID, Number_Of_Copies as '#ofCopies' from BOOK_COPIES
SELECT BookID as 'BOOK_AUTHORS.Book ID', AuthorName as 'Author' from BOOK_AUTHORS
SELECT CardNo as 'BORROWER.Card #', Name, Address, Phone from BORROWER
SELECT BookID as 'BOOK_LOANS.Book ID', BranchID, CardNo, DateOut, DateDue from BOOK_LOANS


  -- END LMS CREATION
  -- END LMS CREATION
  -- END LMS CREATION
  -- END LMS CREATION
  -- END LMS CREATION







/* 
  BEGIN STORED PROCEDURES
  BEGIN STORED PROCEDURES
  BEGIN STORED PROCEDURES
  BEGIN STORED PROCEDURES
  BEGIN STORED PROCEDURES
*/

select * from Library_branch
select * from book_copies

select * from Library_branch

-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch
-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch
-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch
-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch
-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch
-- Stored Procedure 1:  copies of the lost tribe in sharpstown branch

USE LMS
CREATE PROCEDURE LostTribecopies AS

select books.title as 'Title', library_branch.BranchName as 'Branch Name', book_copies.Number_Of_Copies as '# of Copies' 
from book_copies inner join library_branch 
on library_branch.branchID = book_copies.BranchID inner join BOOKS on Books.BookID = Book_copies.BookID
where library_branch.Branchname = 'Sharpstown' and books.bookID = 1

-- or

--select books.title as 'Title', library_branch.BranchName as 'Branch Name', book_copies.Number_Of_Copies as '# of Copies' 
--from book_copies inner join library_branch 
--on library_branch.branchID = book_copies.BranchID inner join BOOKS on Books.BookID = Book_copies.BookID
--where books.title = 'the lost tribe'

EXEC LostTribecopies

--DROP PROCEDURE LostTribecopies

-- END Stored Procedure 1

-- Stored Procedure 2:  copies of the lost tribe in each branch
-- Stored Procedure 2:  copies of the lost tribe in each branch
-- Stored Procedure 2:  copies of the lost tribe in each branch
-- Stored Procedure 2:  copies of the lost tribe in each branch
-- Stored Procedure 2:  copies of the lost tribe in each branch
-- Stored Procedure 2:  copies of the lost tribe in each branch

CREATE PROCEDURE LTbranchcopies AS
Select A.BranchName as 'Branch', C.title as 'Title', C.publishername as 'Publisher', B.Number_Of_Copies as '# of Copies'
from LIBRARY_BRANCH as A inner join book_copies as B on A.BranchID = B.BranchID
inner join BOOKS as C on C.BookID = B.BookID
where C.BookID = 1

-- or 

--Select A.BranchName as 'Branch', C.title as 'Title', C.publishername as 'Publisher', B.Number_Of_Copies as '# of Copies'
--from LIBRARY_BRANCH as A inner join book_copies as B on A.BranchID = B.BranchID
--inner join BOOKS as C on C.BookID = B.BookID
--where C.Title = 'The Lost Tribe'

EXEC LTbranchcopies
DROP PROCEDURE LTbranchcopies

-- I'm not sure how to show branches with 0, but it's all the rest
-- end stored procedure 2


-- stored procedure 3:  All borrowers with nothing checked out
-- stored procedure 3:  All borrowers with nothing checked out
-- stored procedure 3:  All borrowers with nothing checked out
-- stored procedure 3:  All borrowers with nothing checked out
-- stored procedure 3:  All borrowers with nothing checked out
-- stored procedure 3:  All borrowers with nothing checked out

select * from borrower
select * from book_loans

CREATE PROCEDURE Nocheckouts AS
select * from borrower as B full outer join book_loans as BL on B.CardNo = BL.CardNo
Where BL.DateOut is NULL

EXEC Nocheckouts
-- END 3


-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)
-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)
-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)
-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)
-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)
-- sp4:  sharpstown books due today (I don't have any due today, so I changed to get output)

-- I think a full outer join may be appropriate for a larger db, but output is same either way

CREATE PROCEDURE sharpstowndue AS
select B.Title as 'Title', BR.Name as 'Name', BR.Address as 'Address' from book_loans as BL 
inner join library_branch as LB on BL.BranchID = LB.BranchID
inner join Books as B on B.BookID = BL.BookID 
inner join borrower as BR on BR.CardNo = BL.CardNo
where BL.DateDue = '2020-03-31' and LB.BranchID = 1

-- or 

--select B.Title as 'Title', BR.Name as 'Name', BR.Address as 'Address' from book_loans as BL 
--full outer join library_branch as LB on BL.BranchID = LB.BranchID
--full outer join Books as B on B.BookID = BL.BookID 
--full outer join borrower as BR on BR.CardNo = BL.CardNo
--where BL.DateDue = '2020-03-31' and LB.BranchID = 1

EXEC sharpstowndue

-- end sp4


-- sp5:  books loaned by branch
-- sp5:  books loaned by branch
-- sp5:  books loaned by branch
-- sp5:  books loaned by branch
-- sp5:  books loaned by branch
-- sp5:  books loaned by branch

select * from library_branch
select * from book_loans

CREATE PROCEDURE loans AS
select lib.BranchName as 'Branch', count(*) as 'loans' from library_branch as lib inner join book_loans as boo on lib.BranchID = boo.BranchID
group by lib.BranchName

--select * from library_branch as lib inner join book_loans as boo on lib.BranchID = boo.BranchID
--order by lib.BranchName

EXEC loans

-- END sp5


-- sp6:  more than 5 books checked out
-- sp6:  more than 5 books checked out
-- sp6:  more than 5 books checked out
-- sp6:  more than 5 books checked out
-- sp6:  more than 5 books checked out
-- sp6:  more than 5 books checked out

-- left outer join shows same output

select * from book_loans 
select * from borrower

CREATE PROCEDURE checkedout AS
select br.Name as 'Name', br.Address as 'Address', bl.cardno as 'Card #', count(br.cardNo) as '# of Books' 
from borrower as br inner join book_loans as bl on br.cardNo = bl.cardNo
group by br.Name, br.Address, bl.cardno
having count(br.cardNo) > 5
 
-- or

--select br.Name as 'Name', br.Address as 'Address', bl.cardno as 'Card #', count(br.cardNo) as '# of Books' 
--from borrower as br left outer join book_loans as bl on br.cardNo = bl.cardNo
--group by br.Name, br.Address, bl.cardno
--having count(br.cardNo) > 5

EXEC checkedout

-- end sp6


-- sp7:  King books
-- sp7:  King books
-- sp7:  King books
-- sp7:  King books
-- sp7:  King books
-- sp7:  King books

select * from book_authors
select * from books
select * from book_copies
select * from library_branch

CREATE PROCEDURE king AS
select b.Title as 'Title', bc.Number_Of_Copies as '# of copies', lb.branchname as 'Branch' from book_authors as auth inner join books as b on auth.bookid = b.bookid
inner join book_copies as bc on bc.bookid = b.bookid
inner join library_branch as lb on lb.branchid = bc.branchid
where authorname like '%King' and lb.branchname = 'Central'

EXEC king

-- run all EXEC
EXEC LostTribecopies
EXEC LTbranchcopies
EXEC Nocheckouts
EXEC sharpstowndue
EXEC loans
EXEC checkedout
EXEC king

-- END sp7