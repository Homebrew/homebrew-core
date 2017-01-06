class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3160200.zip"
  version "3.16.2"
  sha256 "ee77c2cc5cc4a7b0a746a1d4496f7aee0d71c558a3bbfcf8e9e0b35416910337"

  bottle do
    cellar :any_skip_relocation
    sha256 "b83b2025bbd690faca7b6eb0b6c30d89c367a6fa39e0e8cea3945fb75a38411c" => :sierra
    sha256 "e942ad3b915b9d9f088859f15cc7504b9ec64a42c78fde8146dab1d19565e673" => :el_capitan
    sha256 "ce89037d1859fd8437ac63cb987d0b1705cff230312f48c9407630351c894e2e" => :yosemite
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
