class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.00.0000.tar.gz"
  sha256 "74a3670d3f608f0fa61265b748f19dd4a975cda18ddfb502217cfff9cae7d562"
  revision 1

  bottle do
    cellar :any
    sha256 "19018de925f884c2cc09f6c83f57d8617dfbc058ae04e4a077ff7c408ee42ef2" => :high_sierra
    sha256 "257fbe1e9149dc8f61f374ba3af4773a7872b3a5deab3de499411e432d5b2775" => :sierra
    sha256 "81eb56bbd0a47c475f1441aa757135e1b3ae668dee66ac0c10cd76e1de1c6273" => :el_capitan
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "postgresql"
  depends_on "unixodbc" => :recommended
  depends_on "libiodbc" => :optional

  def install
    if build.with?("libiodbc") && build.with?("unixodbc")
      odie "psqlodbc: --without-unixodbc must be specified when using --with-libiodbc"
    end

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--with-iodbc=#{Formula["libiodbc"].opt_prefix}" if build.with?("libiodbc")
    args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}" if build.with?("unixodbc")

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
