class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2016/sqlite-src-3150000.zip"
  version "3.15.0"
  sha256 "c68a7064b1932aa8c40f9b1e644ab899771530e16d514ba4a065434666d4a3a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a62a920492d845680c215e2e7805c2f3b275929d6af4043260bc9427ea243e7a" => :sierra
    sha256 "a792fcfb8159b9c2aba9def45ed7e0d79c98c82838aee5f19ea44e506acd7a75" => :el_capitan
    sha256 "14e2af6bb52348665687fe87f2235f3ba70ab15baa7f4aac7fab2fb8e17288a1" => :yosemite
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
