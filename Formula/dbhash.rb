class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3270100.zip"
  version "3.27.1"
  sha256 "f0fcc4da31e61a9c516f7c1ff21ec71ad6a05b1fe88f7f0b4d9aa54649c85986"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1c8c8483e02a795de5515c11b1ec21b15c30ca82c3ac9f87154322fa4237973" => :mojave
    sha256 "2207c65b8956bccd27056dd65c905b73dc4e41eab4a86fb4dbeb04405d1eff82" => :high_sierra
    sha256 "bcaf1062b066f14132261ef326ba56bd827f05c2abf4957a32b35cd12b582167" => :sierra
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
