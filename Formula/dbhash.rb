class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2020/sqlite-src-3330000.zip"
  version "3.33.0"
  sha256 "90bf7604a5aa26deece551af7a665fd4ce3d854ea809899c0e4bb19a69d609b8"
  license "blessing"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c15b1a7f943559d1fc5f1ff3ce17c29d6ab54889aab413fccef92ea83ebb446" => :catalina
    sha256 "09e619708878d1b09a08e398f326409d32b333e2130463a576ea24daaee12e31" => :mojave
    sha256 "961c5f59efe16bf5e88a8876277faf106efe0786db58fe46feb36e1ad5ae8246" => :high_sierra
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
