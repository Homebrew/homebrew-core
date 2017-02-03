class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.06.0100.tar.gz"
  sha256 "050c80b25eb6553a718b9ab4ac00dcbadf7a13ee5ae637c30f7dcde8f4a6c962"

  bottle do
    cellar :any
    sha256 "b135e713eef4c0f66e7fddefe4186810baf9b56a2b3799eefc00ff8e64ef7e00" => :sierra
    sha256 "4661e56ba0466dc527e5917e858b12a2a5f5d54b4eed9e4433b44ef32435e644" => :el_capitan
    sha256 "3d9de332566373f67eab7843324d4b7c38a5c037ea61baf89f641a5f0db78f6a" => :yosemite
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
