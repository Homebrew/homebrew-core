class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.1.3.tar.gz"
  sha256 "bd08d2b7e6b7819fec611f02ff5b48a53298d46f733385f12e83289c017f2d1c"

  bottle do
    sha256 "fd9b19bd8f1706e31f8aa64f03845f9e22aeff5a94532c78fce1a067f4060b23" => :mojave
    sha256 "669574d37d29bd6a2f6d4cdc6ffc77b98b81dbc00d867c347d6e2adb2905583b" => :high_sierra
    sha256 "3666a4d54c227e39ec309d786da7f5c06de0ef8fa92c2e3ab767a81fc03107f3" => :sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

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
