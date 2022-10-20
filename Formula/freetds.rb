class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.13.tar.bz2", using: :homebrew_curl
    sha256 "d4cf90094151fdcdda128ed18cb0a6bf65b308be352b53449943b5249c5b48f2"

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
    sha256 arm64_monterey: "2b4301a10d1b9e0028bee7fbcf25e1a3ab820d55f42757840ef8585effed8bf2"
    sha256 arm64_big_sur:  "9fd5197b165701fd7fd8440c81f1c2398855014164beb1fa479e445acd6cd3ea"
    sha256 monterey:       "61e9683fdeb50cba00ddcd6522dccae2215eb151c08b9cb8dbd31024cea663c3"
    sha256 big_sur:        "8c9fc1558d5f485ce81d6acd26b927b3fc64d8535f08da37c4f4c6b780484d6d"
    sha256 catalina:       "b97ff8ab5c902de575576119a3707cfcc507a6dd8fd8e1fad8507c51bc08f019"
    sha256 x86_64_linux:   "6ebcbb77a25d55be26cf9480a61423bd88d0c646619b7c12a445f4a0de6636d4"
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
