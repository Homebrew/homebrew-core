class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-12.02.0000.tar.gz"
  sha256 "7b00d99ee729c06cfc784ab43deb7dee77761b667dd62122c2cb0cd7b043ba67"

  bottle do
    cellar :any
    sha256 "6ecd918abfb4e8bc95299a8efaeb2d9b2d772caee48d14108a6eeb9781f84776" => :catalina
    sha256 "34900a66170b407b00a65824165fb0ddb2bc6d585ef4c9bba75729d73ee32775" => :mojave
    sha256 "3cb37c6a2885d5abbd75b74167b0e6a93f29edbd1d36ad074bdf438bd7d1cb39" => :high_sierra
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
