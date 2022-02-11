class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.9.tar.gz", using: :homebrew_curl
    sha256 "923dff0c8cf258ef33d661d71bf431ffb55218f14e0026f75d361951c2e92dbb"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8717760292249498afc8e822bf848ba8ad694c6898a0a5d40ab404c8deda8102"
    sha256 arm64_big_sur:  "dbe9bf2aa2d5c08122bcf4687879d4b12632690ee8800fb85891a02557a4130f"
    sha256 monterey:       "97f3205764a327250f02b8b865c64da309cd7e678d00e1c8ab8788f10ea207d7"
    sha256 big_sur:        "cbd58146111dea706ee06f72c1ca3283a75e63f08d9c0e200aab5c89a12b7e50"
    sha256 catalina:       "0a6c953da2cceddcad1aa6f0dff6a50bc07fe587699d6f68efe502f393fbc1cf"
    sha256 x86_64_linux:   "1d141167d7f3a52ec24f48421689d912e14ecb2d45777cff07a3259621a70b0a"
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

  uses_from_macos "krb5"

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
