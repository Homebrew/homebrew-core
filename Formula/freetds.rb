class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.6.tar.gz", using: :homebrew_curl
    sha256 "8bde8865b11581b0860459b85d35c529646258a85f93e3f52b0a6f9933d865aa"

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
    sha256 arm64_monterey: "a9015673d06ec58bc4e2093877ef664109aa92123d719e298661e0b00ac5a8da"
    sha256 arm64_big_sur:  "ca46d09b7ca10637be06219f9007e9c853874a7db5975ced31658def1f8308aa"
    sha256 monterey:       "5a0fcd0da54aa77092c9ac5c00b51db531a06e1de37babe814e0b32f544c25cc"
    sha256 big_sur:        "ac455c65b4ce4144b3b4353298315b51819d8b3a28a3d3c6cbe5fca08837b6a0"
    sha256 catalina:       "40802d5deb5fceaf36674dd41a6af4a13286befcbf1a098a56c3b26787667222"
    sha256 x86_64_linux:   "48fb32239308869fd0d4254145dde1d131ba1b78d8a629c4ee332a723c022211"
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
