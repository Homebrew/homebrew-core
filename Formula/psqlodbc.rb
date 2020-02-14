class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-12.01.0000.tar.gz"
  sha256 "fdbb3edfcc9730787bb84d76e61fcf7584ced1913d7bfccea0bcbf5a150a5f74"

  bottle do
    cellar :any
    sha256 "0654b174ebc79e5dba8e4cc01dbf23dd666b267ab51a13476f98f3576b844f01" => :catalina
    sha256 "73e790b93d40879e9011e3f36ebd26994175650736524c51c1e45b1fbcf6e4d9" => :mojave
    sha256 "9b7c956c86df2de006e1bc44976dbb11bdaf16f8ee7c7c9d9d1ca6ffc3715d2b" => :high_sierra
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
