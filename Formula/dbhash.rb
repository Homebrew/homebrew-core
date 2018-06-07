class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3240000.zip"
  version "3.24.0"
  sha256 "72a302f5ac624079a0aaf98316dddda00063a52053f5ab7651cfc4119e1693a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "5228069102b005572a09f79b92427bff1e4887506e0cb06386f6fccf4d322a09" => :high_sierra
    sha256 "5dd776ca04b4990be30d601a2cc7d3586d34336c101c0fafa7fa378b7dc590b7" => :sierra
    sha256 "b4b12de45f17ddf54d7aef8b59499c6f470dab14739d7ab6291bbcd061808e7c" => :el_capitan
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
