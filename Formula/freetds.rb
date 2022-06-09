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
    sha256 arm64_monterey: "faa0e171a44c2510f2491af687a6297b74ca3b29e472516979ec73d976bd208d"
    sha256 arm64_big_sur:  "240dcce61a4f68fc5da83551e5cfe3ca945dd808a0d8a21d3e1353c9a6b57fba"
    sha256 monterey:       "41568d58b6da040e52ed168ead0c8226caa96d8fedb4a8563b0d368563c2615c"
    sha256 big_sur:        "9320afe76db310c709112f50405c91efbf674def250150b70887ccf65cc43660"
    sha256 catalina:       "c2789b9f8e0660ccafd56165cb2f13ff3518767011a281373f1d6df031924f12"
    sha256 x86_64_linux:   "344da964bb37b3b10d955e27bf65acd43a474c891c6eed65d1357e09685cf712"
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
