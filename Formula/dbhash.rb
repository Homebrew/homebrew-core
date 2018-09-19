class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3250100.zip"
  version "3.25.1"
  sha256 "e62f41c0b4de6ea537b70dc24efc37bd56e39bf6ceefcef20a0542fd912d7fae"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc17cf63c979e53dc94725c28966f06a6ff8de6d768036573592333859afa248" => :mojave
    sha256 "2301f532b07d78e0699b17d1260756677b6fabea758606eff4f3219ac670a60a" => :high_sierra
    sha256 "35f7d5b81774074b2baec8d7f77a668c94de38c815ad55a164cec5c9f1c48e2c" => :sierra
    sha256 "8b83edeb5b8321459988bc3cfce2f05072ad4ed70ac542179c5a8c62501f2539" => :el_capitan
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
