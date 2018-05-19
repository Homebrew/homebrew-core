class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.03.0000.tar.gz"
  sha256 "0d2ff2d10d9347ef6ce83c7ca24f4cb20b4044eeef9638c8ae3bc8107e9e92f8"

  bottle do
    cellar :any
    sha256 "50c7b95ba79174f4ef553fd7ef2877ffa419c1d1cfc4d71f88ace5c6a61a0fbf" => :high_sierra
    sha256 "8d87b2eacab320536c900cb4ee49bb28c30f4c895a6ea28cc04ff886ebc66fd8" => :sierra
    sha256 "672ce7087dfd4ec055c46aa1ccac3ea1b224b453aeacf8c56ffa68eef3a6fbf4" => :el_capitan
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
