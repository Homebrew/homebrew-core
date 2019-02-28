class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3270100.zip"
  version "3.27.1"
  sha256 "f0fcc4da31e61a9c516f7c1ff21ec71ad6a05b1fe88f7f0b4d9aa54649c85986"

  bottle do
    cellar :any_skip_relocation
    sha256 "a98ee3f348c1f12a797f2b54342ebb7acf2f1776a679d863c021ad148cb36a60" => :mojave
    sha256 "394c4c5eb9af25e619f5567898ff29afd964d4434fb21bed665e613ec28a78a0" => :high_sierra
    sha256 "0dd992e07dfe8bcf4cd7e5fc661338009fa5924586f1f1e95599292d2595a590" => :sierra
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
