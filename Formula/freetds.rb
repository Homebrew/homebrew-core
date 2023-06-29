class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.18.tar.bz2", using: :homebrew_curl
    sha256 "1d8561d57c71991a28f4681343785c23a6a3eb54d5bcd23897d07e3825ff2d56"

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
    sha256 arm64_ventura:  "401fbc78a90d1ac0f10cd33f3f2e9dd994cb24a8ee3935239c27af169b256c92"
    sha256 arm64_monterey: "a476ecce2a3cdcdd655170d2384af73ff18c358a4afb8f9ce8a3b06c4006c8b8"
    sha256 arm64_big_sur:  "d868ad79b732ec26cf234fa55bd5d1575d947b0975ae64e0114179a0fbb42f58"
    sha256 ventura:        "1ae9e66836c282ef743a2ded9663c950660ede445d7b2884079c3f29d23aeae9"
    sha256 monterey:       "a34e1b15d64308cf342814dab06b9134c8f020b848be14fe0cef949523c12edc"
    sha256 big_sur:        "c28a7fa03042955bba685aa60f930f23929f322f87f32ec8453718e41113a139"
    sha256 x86_64_linux:   "173faab88de808f8b3b517d2d6ac381cddcce95f85abf9bcce80da2bcdcd0188"
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
