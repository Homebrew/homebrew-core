class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.06.0400.tar.gz"
  sha256 "51f7c752e987d8f606f0c53aef2881cc246ee6d08155863b49990f685922b7ce"

  bottle do
    cellar :any
    sha256 "43662f7a39cee6a6fbc40c91fe1002405bae906900daa67b9a4a71faa92cdd44" => :sierra
    sha256 "c4423ead2ce18a484ed122a0537d8a1b11b20772f35a31f1960a5bee602fc6d0" => :el_capitan
    sha256 "7594c0aee1fd22d63ed7fedb4394c49499bb7612686f4b354eb56bbf2cfaac7b" => :yosemite
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
