class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://sqlite.org/2019/sqlite-src-3300100.zip"
  version "3.30.1"
  sha256 "4690370737189149c9e8344414aa371f89a70e3744ba317cef1a49fb0ee81ce1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ea365cbc64a6623313e4d6701ac5cfe12d14b76be8b6fba72afdb47129327d6" => :catalina
    sha256 "84322ef8c2737104776358d3ddc6f253ce4e4d9bf464d4d2da1fa8c56bba7d2f" => :mojave
    sha256 "953a02effe120859def6682480aa659fd137163ff1334d247c2ebd20472407c4" => :high_sierra
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
