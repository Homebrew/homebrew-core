class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.5.tar.gz", using: :homebrew_curl
    sha256 "7b4c6d6afcd91e81ccc19daf4f8f515fec1485cbeacb2ff1e9241608cc053ac5"

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
    sha256 arm64_monterey: "f69417fcea42bd86060f0901c0dd4a4d7e0083930e997a95421e9802ea7bc483"
    sha256 arm64_big_sur:  "550413d6bbbe8709747b153d18d6295aab059a5388aa316940fda057cd42341b"
    sha256 monterey:       "555c54839ed6342d24d2de1e2085c335462c48c94f116d2d57ba3a03b6d1bdfb"
    sha256 big_sur:        "4c0127b6c645d73321266b042fa43182d0dff6039a8caa7da10459de2b026b56"
    sha256 catalina:       "1ae8a6e5db4b58d658576c2181af9ef55bd7b9c000d065753e9724bf3e8a4646"
    sha256 x86_64_linux:   "0d7eda83a905e30f68367a91179e68e4d872f28a9b818840e906f45fbdd6df2c"
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
