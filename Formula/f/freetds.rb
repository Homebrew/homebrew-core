class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.20.tar.bz2", using: :homebrew_curl
    sha256 "20ae11f3b806e4fbc0fa0b5931fb473bb5748bee9d487f6aa12885083578a5ed"

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
    sha256 arm64_ventura:  "4ffa11f6eb718120ff017a3407a40fafe3f2933d37f34e816bd40b0731719974"
    sha256 arm64_monterey: "4fa8ee2c787bf7401ed5b11293f6e35aa8f085f2a8b78ab5647384f7e08205f1"
    sha256 arm64_big_sur:  "01a8ae05c60d2baf841e1d7748c73df29270fe9631fc79666d5ebd36fe918581"
    sha256 ventura:        "417dbf14ad640826c8cadbbb089b1437a37058ef6c0b295ff1ec30e3e8f07761"
    sha256 monterey:       "14fb4ec50ee6f57e531ae990e25754dbc04e80d9f0a385d8ebe23b8a571b4aa1"
    sha256 big_sur:        "ad42d0fd4e34ee3e8494a1a25f3c5b7d4fd9acaeecf49723f50c4eb7164ab8c9"
    sha256 x86_64_linux:   "459bec628449c248b6d93c714c1a8caa745e5a3c774ba093af40c1e969b6a8ea"
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
