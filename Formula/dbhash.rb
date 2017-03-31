class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3180000.zip"
  version "3.18.0"
  sha256 "eab4d137abd5aa1164244a5d558c9a02122071daf36984b236f8441d749b9ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e264827c9d0117b9da577f66a320bee1ff59eb2fd6052a72ce601483363e3bf8" => :sierra
    sha256 "7b8e197c46792f3b4314273d3d7466a6a185643b8881df2b2d46b6f0be828bb4" => :el_capitan
    sha256 "4ddf4f37ab2b2cc9a4e422cd94c15c3a076127f50f1d6855ec66265ef2e34710" => :yosemite
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
