class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3180000.zip"
  version "3.18.0"
  sha256 "eab4d137abd5aa1164244a5d558c9a02122071daf36984b236f8441d749b9ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "735393656e4cca0a6ac15bf647aeed698dd57a59d7ba68bbd687e9979a72869c" => :sierra
    sha256 "c7463aa4e9afab28ea1f4349831903b941cc40c78b8d40b3e94e1ba73ce0941f" => :el_capitan
    sha256 "74dc17ea29958525c00c9b01632c1541b97fb098e7aba409564268827cb1808d" => :yosemite
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
