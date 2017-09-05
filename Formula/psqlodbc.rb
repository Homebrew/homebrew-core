class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.06.0500.tar.gz"
  sha256 "c784db84f3f9792c060d4c598835588c992f97cb4144d532b0cd1af9908bd401"

  bottle do
    cellar :any
    sha256 "a17ad86afd1f5f167252d7c2cb56c930b0bff58cd523093741356ed952ac6f1e" => :sierra
    sha256 "82683ef581a38640fff97282ae3ccbbf3206490bfdfe8e7c48c4686f794a8550" => :el_capitan
    sha256 "5738e63ed41a5fdbc0128ad1e42dd637248f9f49ebba2f83d96ec5e3126352f7" => :yosemite
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on :postgresql
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
