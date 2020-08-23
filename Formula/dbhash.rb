class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2020/sqlite-src-3330000.zip"
  version "3.33.0"
  sha256 "90bf7604a5aa26deece551af7a665fd4ce3d854ea809899c0e4bb19a69d609b8"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
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
