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
    sha256 arm64_monterey: "7dbe87d178a9d87cc4e985ce34b6020843a87b26b53f42c130c7fa4de84648fe"
    sha256 arm64_big_sur:  "d53aac83ae0f42c72d4a0fe9fb05e9fa825262417d0ffd8ea3f0cfd653dfed0e"
    sha256 monterey:       "7abc0d95782294250eb1b8ab3905bf1df321922e3ddeafb88d6cebb571d20bb2"
    sha256 big_sur:        "d68269954355ab7751a6db862f8a031ab02620c5ec6987c5c32ef0b4d2c0587b"
    sha256 catalina:       "10f11c81b03132bf260a946f2ffca81b8e8484cbeb28cb8f0c633ae3a41efa5d"
    sha256 x86_64_linux:   "3acfdaafd32363324e412d9cfebb23c610e76663408a85e9cab78dc579dfe3b4"
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
