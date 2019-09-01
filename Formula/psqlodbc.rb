class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.03.0000.tar.gz"
  sha256 "0d2ff2d10d9347ef6ce83c7ca24f4cb20b4044eeef9638c8ae3bc8107e9e92f8"
  revision 1

  bottle do
    cellar :any
    sha256 "260c8444a2a9b34d77bd08b523ff5e570006aca67527a9afdc3ae5f84c31eb7d" => :mojave
    sha256 "e24fc6b6c219c8ee08a1448fe8fb8fe7e70cadae99d197c21838515dc96751de" => :high_sierra
    sha256 "420b5d885afc1839b1ec764e07d28803cfe88680c233dd7833d22cd382df8c40" => :sierra
    sha256 "846df80d05b7692bb2cf7d3fd13b9be0e720e02dabfd32c14a560385e0592895" => :el_capitan
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
