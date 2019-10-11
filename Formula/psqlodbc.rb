class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.03.0000.tar.gz"
  sha256 "0d2ff2d10d9347ef6ce83c7ca24f4cb20b4044eeef9638c8ae3bc8107e9e92f8"
  revision 1

  bottle do
    cellar :any
    sha256 "f1e37e8b4f0c789eabc6760b20b3e877d10855b4f6bc1ac13b6a2b70590be15b" => :catalina
    sha256 "49fa960ad8d53bc332464cca31c41168b252b486da1f3aee9afe8a8937df572c" => :mojave
    sha256 "3c06991bd75a012f7087a11940597221092f780efbf686e88770c996df05e278" => :high_sierra
    sha256 "b9bbfb50bdc7b77fe47a6b1eebd80adaf2ae8fc2b1f5be527aeb531ddfc585fe" => :sierra
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
