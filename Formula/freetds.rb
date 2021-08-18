class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.3.1.tar.gz"
  sha256 "dc8303d3b270f42309dfef04a03e17fe2ad31555df8d557c3c378bb2e9239303"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2ecf06b662ffadd4c4ca07a63cef9913915c43da7657ee5a035411b9d6fe8878"
    sha256 big_sur:       "d5af44165c7b0f2b41f2cc7b416badfd2cd0aeeb0c380cbdb06e14a2729b7399"
    sha256 catalina:      "8ba7b87f0cbf655965d8e21df824e70cd9503da77f25f10d2b062247ffcaa72d"
    sha256 mojave:        "dcf2635a61a19b41f34a5f8ecc7dbdda9f11c5305611d5bc3597df6493519d46"
    sha256 x86_64_linux:  "c9759ef611d977986d751514f7dc24c9b73bbdd1d1071baf4f4785ea93628f42"
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

  on_linux do
    depends_on "readline"
  end

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
