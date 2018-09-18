class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2018/sqlite-src-3250100.zip"
  version "3.25.1"
  sha256 "e62f41c0b4de6ea537b70dc24efc37bd56e39bf6ceefcef20a0542fd912d7fae"

  bottle do
    cellar :any_skip_relocation
    sha256 "afb5fe6d4f8c97919be56e14b397f0a4dc0077280b935bc5ea35a8880dc05dc9" => :mojave
    sha256 "dea08361e7ccc57129fb61956b49d6a340435857af79abc2b9362f1ce1822896" => :high_sierra
    sha256 "238e1fe85b28c0a4253cb8ceef006a20524ba2b65521ef4b4456fe4e93b3000c" => :sierra
    sha256 "50fd93d9c788bc2c5b98e20e2aa2c29cc3cd479ed06bc923d7745cc357401204" => :el_capitan
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
