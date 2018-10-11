class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.00.104.tar.gz"
  sha256 "c4f51525f2dd722fe3651913d4ea194798211293f195c38fc3933cc6db1dae42"

  bottle do
    sha256 "bcd468f7e79650683c46172ddf35606fe36453009b54877e3bf6e941ec153312" => :mojave
    sha256 "5ed416f2e9b2308da78bb031e69866f12343b288db3cbe08d4c892cf65a598ad" => :high_sierra
    sha256 "b22d8d8bf72c139e56ec7d5389a6459669852e17fe2e2e84ddcc352e694995d2" => :sierra
    sha256 "1d280805055fd549f0ad1da5d79387aa4ae18e11f486f07f619ba6f135d776fa" => :el_capitan
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "unixodbc"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.with? "msdblib"
      args << "--enable-msdblib"
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
