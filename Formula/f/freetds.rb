class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.19.tar.bz2", using: :homebrew_curl
    sha256 "35e69ae5ccd7045c8a5291e9fc2b23844a9fdfef6b4e0ee7f62a069579012b85"

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
    sha256 arm64_ventura:  "b695d5f390d024b8ff8cea4971aa07ae7a008c90ea4f155420a3808f08221f36"
    sha256 arm64_monterey: "8ee494b9f729e5f005275e6a7a6d90b594fd4730456ff60d454ba4ffa98deb5c"
    sha256 arm64_big_sur:  "3ad4bf87dae6562e91cd73638ff210bf3d6d431aa20e7a8163dd5abcf6668353"
    sha256 ventura:        "77e436bd5a5b5d048ba54a128838aa74b10ba8bad3aefcbef57f2a1c05cccb44"
    sha256 monterey:       "9bba20ed20b88ed0e2415a5d4816e2aef37e6e9669b363d65148e10018ade8bb"
    sha256 big_sur:        "c19add5431c9e776f33f4b7d8ebc29ac6d4b559980fb70185b3e4275f2bb32e5"
    sha256 x86_64_linux:   "33c5b54fcf00715384da5de2ebc063361cf1b2250b418e77813102d17bda03ff"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
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
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
