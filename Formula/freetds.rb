class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.1.4.tar.gz"
  sha256 "e59b7111001b95de77412b5ca8ec45fae240d7273f874e42fafbd8e1083b5556"

  bottle do
    sha256 "d512bb67c8126eed281c3be01ac0e3cb2ba88042b884a2724aa5aefb63ee2b03" => :mojave
    sha256 "b1f7dff8f3bcb5643d28b9dc553a95549a9d767c98bfa69bda7ce2e71509041a" => :high_sierra
    sha256 "a4fddd9728600ba9914b840ffc536f412e5af9e68854449d4a53ffcfd8be57a4" => :sierra
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
