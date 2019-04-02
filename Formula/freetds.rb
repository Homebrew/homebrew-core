class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.1.4.tar.gz"
  sha256 "e59b7111001b95de77412b5ca8ec45fae240d7273f874e42fafbd8e1083b5556"

  bottle do
    sha256 "66ce6291c83495f7372ae00559eccc8044c19d61642f5f02a375c22e63ac88d5" => :mojave
    sha256 "79172589792275fd0ae469364a01b8ffc617080687a6523f1401c210d122cb08" => :high_sierra
    sha256 "d1d7e4eb2fe06e76e8b257770477969b70d4bc3159bd1d08b8c759ca1affdfac" => :sierra
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
