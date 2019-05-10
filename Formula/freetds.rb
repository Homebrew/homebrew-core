class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.5.tar.gz"
  sha256 "f0c1cb91358ada9e50fbfb452e6726ac74e4644b48d73949ab4b7f3950aaed13"

  bottle do
    sha256 "ffab70193d6da457d9b195dcb43950190f6d6feae8b3d3aa5a1b9c1a790b970c" => :mojave
    sha256 "9db24d40af6a549e5b2faf7ab51c79bf9f92a3b820255677e8ce3603ad211010" => :high_sierra
    sha256 "55fe54fcce57032a9e03467a04883e5970c66873fc7f73dcfa968d6b9afecc91" => :sierra
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
