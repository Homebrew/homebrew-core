class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3220000.zip"
  version "3.22.0"
  sha256 "7bc5a3ce285690db85bd3f97034a467e19096b787c9c9c09a23b1513a43c8913"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a6286b94d8d4bbfced78c4c3fd032258c3cb2acce862c2878b14734bb9dc3df" => :high_sierra
    sha256 "10723879ac8dd97b58cc8d424e8c7183faa56e4b1a214ddebc93c77c918203f9" => :sierra
    sha256 "dcec03c7e7cd6eaeb99446184f9335859c03833f04e624abf51db097565bae64" => :el_capitan
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
