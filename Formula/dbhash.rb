class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3280000.zip"
  version "3.28.0"
  sha256 "905279142d81c23e0a8803e44c926a23abaf47e2b274eda066efae11c23a6597"

  bottle do
    cellar :any_skip_relocation
    sha256 "d579372c8b7fc498cd545ead0b47d133178602117770f3d3996a9c1175d11760" => :mojave
    sha256 "168d83b2b8e53d2fac99912b8dc61be5126117bef0eece2ed6e7ac173f47a6d7" => :high_sierra
    sha256 "b13eb7ca09d90230bd4858879be635b0e4418b45d5a7d1c30a4cd844144987e6" => :sierra
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
