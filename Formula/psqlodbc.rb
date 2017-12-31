class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-10.01.0000.tar.gz"
  sha256 "87ca436f268b92fd525113e78133f65b444c6feec474837c7ec39d128eaecab3"

  bottle do
    cellar :any
    sha256 "fd55b77d27a61bfb8715108dd35ae49cfef0cc639d1454566ccc0c26031ed4cd" => :high_sierra
    sha256 "af1ed0807e1dfe2921418c7ab30fff91b9f3afd4164874029c22e43f6fc7d562" => :sierra
    sha256 "d9de616b9efcfb8ff1370cd7927f195aad1d2e21ed8603f0126c074a96f8b4dc" => :el_capitan
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
