class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2020/sqlite-src-3340000.zip"
  version "3.34.0"
  sha256 "a5c2000ece56d2de13c474658b9cdba6b7f2608a4d711e245518ea02a2a2333e"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "137c6454f067e88e0257bf8d29bc64d8efa201dcb1cb5770646c1a1569a0e34a" => :big_sur
    sha256 "286b4a753cd443251a2b9b27d2ff813faf384a3c78940c2bded450d391ba7a66" => :catalina
    sha256 "f9f1001a4e2a887070762636737a144d13e53f00dfa39278c9535cc448b6f91c" => :mojave
    sha256 "7e973140b25ac83fb8d8dd77a2b7b4ee5cf13f4b10d1a27b92c1ad4180cf71e8" => :high_sierra
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
