class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.53.tar.bz2"
  mirror "https://fossies.org/linux/privat/freetds-1.00.53.tar.bz2"
  sha256 "f9b99c9767cd1589f141e0e50f802cf697147196073f559145c6a8ef4feca7b5"

  bottle do
    sha256 "61381f1e99a974de281c5489c88ad6a400e1ff67db6e4dd804eb5bddd3dc98b2" => :sierra
    sha256 "99fe47ef9e357114c9af3fc02a051a4a7fd0b177fdb76acd684f07f8125a4079" => :el_capitan
    sha256 "532aa781b8b1b9e62f795acce5cebb2abfb4641692e811dae1a7edd84b3cfb45" => :yosemite
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "with-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "with-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "with-krb5", "Enable Kerberos support"

  deprecated_option "enable-msdblib" => "with-msdblib"
  deprecated_option "enable-sybase-compat" => "with-sybase-compat"
  deprecated_option "enable-odbc-wide" => "with-odbc-wide"
  deprecated_option "enable-krb" => "with-krb5"

  depends_on "pkg-config" => :build
  depends_on "unixodbc" => :optional
  depends_on "libiodbc" => :optional
  depends_on "openssl" => :recommended

  def install
    if build.with?("unixodbc") && build.with?("libiodbc")
      odie "freetds: --without-libiodbc must be specified when using --with-unixodbc"
    end

    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
    ]

    if build.with? "openssl"
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    end

    if build.with? "libiodbc"
      args << "--with-libiodbc=#{Formula["libiodbc"].opt_prefix}"
    end

    # Translate formula's "--with" options to configuration script's "--enable"
    # options
    %w[msdblib sybase-compat odbc-wide krb5].each do |option|
      args << "--enable-#{option}" if build.with? option
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
