class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.11.tar.gz"
  sha256 "0f9d2f56f5603585e600ed6a0b48e99a9753747717a0230301c201ee41e5fb37"

  bottle do
    sha256 "1a3be639e4b71bd17f51b41b26fbe553b4f41424f313ea24c3ebb844b6980f6c" => :mojave
    sha256 "d57f34d7c05afd47c56e2d81ca71b45cba9a5d81a58bcc0ed7e379d986f50a4f" => :high_sierra
    sha256 "f5e55a33e67db0387f2e88e7899e16db687b3f6c22d93da1e77e2d0e333ac2c1" => :sierra
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
  uses_from_macos "readline"

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
