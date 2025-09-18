class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20250905.tar.gz"
  sha256 "f409fa3803bfc540869b78719400bceda216842e4da024f83ca3060241d9c516"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "21836c6bfd09c433990d9b12bb501aa7ac8feebd14ea029641aed21cf554f983"
    sha256 arm64_sequoia: "84f62246d0ccb4bff497544881fed2a06a9e81187c3bde6f7f738ee2fa0b0785"
    sha256 arm64_sonoma:  "162fcedc8e2c921387cca0575cd8d2bb6c4e63100d66c32de4a0847aa6a1ac60"
    sha256 arm64_ventura: "50231a2c92e93c455f44c1f819ab7d5cf65f6c758276c2342a268fad5be978e0"
    sha256 sonoma:        "811727648432674b186b76a30c6472b140c2d232e6432f7ada288df305f9739d"
    sha256 ventura:       "b54a11db96f0f03e92a308f74985cd36b6d4d99fc2534007944afca740ca19df"
    sha256 arm64_linux:   "e1463cece45b7b43920c75e12f69167ec02502559a71e0f994e83aacf8a6760d"
    sha256 x86_64_linux:  "6423610986b83a52a0864ee3ea0123ee822d30f5eff3d69c9be8d945860c63f2"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
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
      --tokyocabinet
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
