class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2020/sqlite-src-3320300.zip"
  version "3.32.3"
  sha256 "9312f0865d3692384d466048f746d18f88e7ffd1758b77d4f07904e03ed5f5b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b48cfd2b1f7e1450a00eec56ea893a015b49574e502c4cef1ceefbc133cdf14" => :catalina
    sha256 "d624c2bbee9a75970dd80c7316f46653876b0032596b0a6e9013bc939098e1c3" => :mojave
    sha256 "37efa4b900a25b20852f92dfa35661cda98d38ddc7d7937e9bbf18c1abce2bc9" => :high_sierra
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

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
