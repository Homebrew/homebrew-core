class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

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
    sha256 arm64_ventura:  "3121d9240917d0efb691d437cd1973123822b0c0fe4197aa9706622588228835"
    sha256 arm64_monterey: "d758f502d2ad3fa04e4c247a6f5779d5332c93f4762a50a3168b039b02be99fb"
    sha256 arm64_big_sur:  "3762aacd59fc01bbe59ffb98fd5cc9ad21c43c26d23e8dd1eb9ac5407eff4845"
    sha256 ventura:        "c8bdefcb961da3602711376ddc9120b811242a7926d970083da5ee65bedddb32"
    sha256 monterey:       "0ed2ea919f87a000da663d772ede6fcfa8adf440abd98b202a9ded057d523d74"
    sha256 big_sur:        "6d5c49c53b46035838353885443eff53021ca3a14860aaad5aec71488b0c83bf"
    sha256 x86_64_linux:   "f865a612715f8584107360d3c0f30f157c1b4ffb6694e3b321cc95e5975c9f3a"
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
