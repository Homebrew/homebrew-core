class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.15.tar.gz"
  sha256 "ebeb9060bcfe54f13ab0fbf8cb72ac95cc6cefbe728a30247516d55334d66a03"
  revision 1

  bottle do
    sha256 "a0753a85a5b04ecde98ff9ed9a02cc2ae9c3d4dc20a697239288743e61429a6f" => :mojave
    sha256 "aa66ed44901cd2c3685691de001d2bd18a123934602c08c99750c6dce379eb38" => :high_sierra
    sha256 "a2e9e4956517f29a2dee0f5902dac9463c6eb12da23c8d7d57a024f27ffea4b1" => :sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  uses_from_macos "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
