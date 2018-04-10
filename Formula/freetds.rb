class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.00.86.tar.bz2"
  mirror "https://fossies.org/linux/privat/freetds-1.00.86.tar.bz2"
  sha256 "d99c1d48c46e239e67abc4aec11aaf8ebd22699d990b6097266ce41db1161892"

  bottle do
    sha256 "88df72ea076302d64ebeee43597531672225108bf43cf892c8a64eb9bbf4a2cf" => :high_sierra
    sha256 "bfa4617502126d992d901e6188a28b825b623debb0b52e1c15160de674c773b2" => :sierra
    sha256 "c8fbaabc75f465382cdd6a2757d414ec9a3dbe75eea41832c825f66a0b242419" => :el_capitan
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
      --sysconfdir=#{etc}
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
