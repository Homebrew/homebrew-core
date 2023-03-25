class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230322.tar.gz"
  sha256 "47f024d4ae2d976f95b626c5fe6cad6ef22ed187426efbd7cf61435ba1790a48"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "dfe562773cad7fc3e15ed43c02a18959e51114ed5cdc27fe3873ea4542b7de53"
    sha256 arm64_monterey: "cb33abce1c1d806a7ec4d7df13b95a9599cc35e7279276a5b474325a04894a06"
    sha256 arm64_big_sur:  "cb5e81ba3b6e50854bfbf46e9e4cf9f691aaa8b50051a2f6408c942ceaf3dbb3"
    sha256 ventura:        "59994a21cccbdddf3d99bc7db646ae5b8c61761f48e45e71917c996169bb07ad"
    sha256 monterey:       "5aa8a643b310ae26c536e79732544e7396459ddf162e5cfe4e097602222b2536"
    sha256 big_sur:        "a3bc1e42d3a011c1c20d34353973189d7cfd72d469247f7974368b6d31721f02"
    sha256 x86_64_linux:   "9cd2589f3e22f89dd1c3849741fe1ff29565b1e7a0a4999610d7984d40858690"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  # Fix finding macOS `libsasl2`.
  # https://github.com/neomutt/neomutt/pull/3780
  patch do
    url "https://github.com/neomutt/neomutt/commit/6d28a555f52e437e5966e769c5cda82e8b643ad9.patch?full_index=1"
    sha256 "17d9af6955ba7267d4ed0b2ca5bfacfa01e81b2de96246ff7c885bef1035eb35"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --autocrypt
      --gss
      --disable-idn
      --idn2
      --lmdb
      --nls
      --notmuch
      --pcre2
      --sasl
      --sqlite
      --tokyocabinet
      --zlib
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--pkgconf" if OS.linux?

    system "./configure", *args
    # Do this in separate steps because parallel `make install` fails intermittently.
    # Reported upstream at https://github.com/neomutt/neomutt/issues/3783
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
