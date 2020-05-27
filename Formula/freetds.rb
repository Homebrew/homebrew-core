class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.40.tar.gz"
  sha256 "79e0492b9c689ad63d8039ec5a7e0dd3cbeced74e6c80d4df7050e5fa6a0f64f"

  bottle do
    sha256 "92f73d362880b0b69ae3447e6c292885052357bd84a6c4c1ee74362cd072f1b6" => :catalina
    sha256 "8a11ffa72bf567985a071d0b487917817418e46ad50e5dfe409d34cd073c2f54" => :mojave
    sha256 "401c3eef9657e8dc6681664c521dc71519a8d74068a85b68cf54086272d7d49a" => :high_sierra
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
