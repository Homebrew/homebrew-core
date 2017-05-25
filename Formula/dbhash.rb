class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3190100.zip"
  version "3.19.1"
  sha256 "4b8b3db73bf63ab35d4a07fe54667a7bc770ede2cf38e6ca2d88536e207034fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "95c52846a55f66caaa76dbeee67b8191fda967df1ddcf20eda58f9171699e896" => :sierra
    sha256 "52db656e35520e805557c6a852ccbca0daeba56e44751a5186ea4630eede3b0e" => :el_capitan
    sha256 "20fdc12abf855608ee2335ae4f8e7e4b72dc60701afe1066b12657e07671882b" => :yosemite
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
