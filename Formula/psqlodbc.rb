class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-12.02.0000.tar.gz"
  sha256 "7b00d99ee729c06cfc784ab43deb7dee77761b667dd62122c2cb0cd7b043ba67"

  bottle do
    cellar :any
    sha256 "3b1ddc35e6778cad2cda6bcb9a4bec0eee15c60c50f7940b49af343363e27457" => :catalina
    sha256 "9070cf9b4b8d2826e2979e4a50b73c16584961ad19c7ec3a38f59e6bc8599021" => :mojave
    sha256 "af640c08e54e2bd684a75b246a25b3ad2ed7a0ddaf3c38d8ca9b60117e620ec4" => :high_sierra
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "unixodbc"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
