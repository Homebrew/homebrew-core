class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3230000.zip"
  version "3.23.0"
  sha256 "22422e1d34ecc21af5d374c328c540a3a6e32d7d6cf3c57be8b51b523b98d633"

  bottle do
    cellar :any_skip_relocation
    sha256 "88d5985464a966c18488043902d35b75b5a863c451669c50d66fe4af6b426d94" => :high_sierra
    sha256 "739f4d154ce2cfffbf7bf3a96c28a340d497993d1ad3652089ced2449cd76b70" => :sierra
    sha256 "202cd2a412656828938384c20e9a77f4cd87b54de1b36862562f04cdc8d0a717" => :el_capitan
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
