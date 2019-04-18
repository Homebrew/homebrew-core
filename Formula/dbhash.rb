class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3280000.zip"
  version "3.28.0"
  sha256 "905279142d81c23e0a8803e44c926a23abaf47e2b274eda066efae11c23a6597"

  bottle do
    cellar :any_skip_relocation
    sha256 "45688ce79eb01b71c74a97e718766413e853a465c62627da904c9b91fa7d5248" => :mojave
    sha256 "73467e8a14ee52307e0837d372c64cc4593cc06aafb196cc5da8c8dc02817616" => :high_sierra
    sha256 "9e6cb4af8fae69f4944be17337514449d460d21410cf9a37a74f44fca64e9522" => :sierra
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
