class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.36.tar.gz"
  sha256 "1c306e658e10a325eefddfd662cec3a6d9065fe61c515f26d4f1fb6c4c62405d"

  bottle do
    sha256 "2e4b532377ca55da4789362b2123b4e890d42cbf8600c8fc89b44983dd887dd5" => :catalina
    sha256 "30890cb1671978000bdb8c48d7aabe28b038cc6d5fc69eea82efb5228eb888e6" => :mojave
    sha256 "f134fb528b5facf98b109ee6f59847517b269b1b6bab725f4738121b2af56153" => :high_sierra
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
