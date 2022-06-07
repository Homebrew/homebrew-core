class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.11.tar.bz2", using: :homebrew_curl
    sha256 "31ab43617cb096788975eb2b5503b32893f1faca2dabe31543b8c09a8d9d1b8a"

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
    sha256 arm64_monterey: "1269da6428952dd2205d7243d717f7c768b388f8c97dd2c5899c0da668cd9ccf"
    sha256 arm64_big_sur:  "078d4483a52ff0885496608ef82660f4550bed24098d2b2a585a6b60afc03441"
    sha256 monterey:       "cbcf2c2b0e0420e0dcb55ce57770eb38e34570a05bd1764df84dd4bcfbf957a7"
    sha256 big_sur:        "25af17c0e0339c5aeff031a3d60cb3396513fc785b76b4aedd2c758c06b0caf8"
    sha256 catalina:       "47061872f4cd163fe5548aa4220402524aacb0cbcc3fc967c63ccb7d11eacae1"
    sha256 x86_64_linux:   "9226bcafdba3369b36694731b46ca9c76670eba2cf26c8f6421ac2e71580ba5c"
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
