class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230322.tar.gz"
  sha256 "47f024d4ae2d976f95b626c5fe6cad6ef22ed187426efbd7cf61435ba1790a48"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "4b3c8c61fde2d7de2b71820d092d2ed608b57e3bd6ece5cb90e329db0673922a"
    sha256 arm64_monterey: "b14f7dbe38dfa60b5917ebd28d5ff1f423643d172f34b12ce80cbf5ccdf6db89"
    sha256 arm64_big_sur:  "94adec37ccdcd843b9ef06fb317181b9bc7a73c1c924cdd539aad9de7317f5b6"
    sha256 ventura:        "280654d534129e77c803df3736faa51b65bec962ea076f612c7281403cf4bf3a"
    sha256 monterey:       "bf490308b5e20353c6497811d78e9e2b07a918c00027b27d61b6bbe25c3f5687"
    sha256 big_sur:        "398a157054e175b0eff40e4112ee859202819760d25cd31469c9e71f570faa4f"
    sha256 x86_64_linux:   "44e72c18326ed9d3d9d3f997bcfa696b93d16ac629660a296f35de3860a59cd6"
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
