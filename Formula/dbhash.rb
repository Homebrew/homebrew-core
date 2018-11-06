class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3250300.zip"
  version "3.25.3"
  sha256 "c7922bc840a799481050ee9a76e679462da131adba1814687f05aa5c93766421"

  bottle do
    cellar :any_skip_relocation
    sha256 "5966c6f7fe596090a76d62d057b1a56256276a08eddc0f818d2da38e719ee5b9" => :mojave
    sha256 "25eb203d01ed087cfb716fc50eb54b4ebf7060e4d1b4bc1c56e1775008b5a02a" => :high_sierra
    sha256 "d273b1953de1e7ee1cae1fe9aedf7e950e01deb86065afe5c24b9ae3c123753d" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
