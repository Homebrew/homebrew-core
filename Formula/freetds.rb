class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.15.tar.gz"
  sha256 "ebeb9060bcfe54f13ab0fbf8cb72ac95cc6cefbe728a30247516d55334d66a03"
  revision 1

  bottle do
    sha256 "abb170ce9f2ac43e53a6e32a1d282551e58f73c161353db26039644b01a8453d" => :mojave
    sha256 "89b2b1240de2034efb9dcd2990c29f2ffdc011efbfae9b09cf30ea9b7ed3ba4e" => :high_sierra
    sha256 "4594adea18d39ba88fc67474f49b131dacee8907290129f5b21319283e2cab61" => :sierra
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
