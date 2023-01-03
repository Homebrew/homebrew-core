class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.16.tar.bz2", using: :homebrew_curl
    sha256 "9e26c5994473dcc008440bd73f89980c56fccbcb28a1eec7765be6e567393481"

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
    sha256 arm64_ventura:  "eed63594ff18b91b502044c5960864f5910beb5f27ed634d85370e78372d4d55"
    sha256 arm64_monterey: "d915287c415ec0b9fd3d23f4abc028bd58d4dacbb4ba67b3d2b61322f4fdd322"
    sha256 arm64_big_sur:  "0fd5f6654336104509aa2e8892ff5de9324c602823c4100d80a8640e9effbcc1"
    sha256 ventura:        "82e4c0ee874eb5062a940808c30e959acdc98cb11d89f1a6d53c8c1d06f60ed1"
    sha256 monterey:       "d7f1f2ef964b56b26344e6c844c79a760b915b2f357b02f4f34649bc0759d47d"
    sha256 big_sur:        "aed24c83410497d496df043c0d7b98efb6853c79911a8ef1ed99a6042f5d1edb"
    sha256 x86_64_linux:   "ef06953e9dc795868a9d0dba7e8586b857da7cac261332150064c347e3e6aafb"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

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
