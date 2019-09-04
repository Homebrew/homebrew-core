class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.tar.gz"
  sha256 "005ddf4b29c6db622e16303298c2f914dfd82590111cea7cfd09b4acf46cf4f2"
  revision 1

  bottle do
    cellar :any
    sha256 "ade5d3ec48bb114117821a89d26fb1e42b03b2dbf5684027dabefa7ccd4ec6bf" => :mojave
    sha256 "d93dcbf0ab557ec5194d4ecf6791ca2b2ec811154a608248690cecba8292a161" => :high_sierra
  end

  depends_on :macos => :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
