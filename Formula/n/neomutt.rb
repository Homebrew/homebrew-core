class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260406.tar.gz"
  sha256 "bd6ef5aa0d53ee23ce15b0f8624a6450d119623931708df998c6ebee7e528d17"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7501350f322f933d19aa4d56bcf70078142bf6ab9129e5e90d6ac15394c783f8"
    sha256 arm64_sequoia: "509e9d89e22a19388182017a82ffff59fe3532498a9c01097a574193fdeda025"
    sha256 arm64_sonoma:  "72ec6ac5d9734656b79251ad9c0e2d2a13e983ed7074e068b60b5fb7b4c10fc0"
    sha256 sonoma:        "f6872649f86357c7c47af0b83c2efba848a5b27ed3d67db4af8ef269970664a8"
    sha256 arm64_linux:   "abf8b127d94dd2730fadc2c676d38a9a2b4bb74d8d70c82105d36745e56ef4af"
    sha256 x86_64_linux:  "1116af9e321ad35bbce757764c101b46ccff5fc285950850bc682c8327072a10"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
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
      --zlib
      --with-idn2=#{Formula["libidn2"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--with-iconv=#{Formula["libiconv"].opt_prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "set debug_level = 0", shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
  end
end
