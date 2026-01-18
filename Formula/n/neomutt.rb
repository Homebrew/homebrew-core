class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260105.tar.gz"
  sha256 "a78e55a0df62b7f98566676d0ab9041aad89b2384bb5c6f3a96302a5cf49968d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "ae40f7fe4d717d8f2ea1567c77a3ea7bbd6c5ce126e06a76d816ccbf49dfae2b"
    sha256 arm64_sequoia: "daa57699dd78f7016360cf181bc5cd497bf19ad7c98339eb4b6cac7e521fe84c"
    sha256 arm64_sonoma:  "5c1b3c7178751668b687fed01bd6667cd4821e0757f79c6f97f145af61b0f8f8"
    sha256 sonoma:        "d937f33c75e4c2d2ad271e537ce3d555e481836284eb31f0ea1c9f219b8e31bb"
    sha256 arm64_linux:   "a573bf0d996f6e4fca4c70e6f162183c122f276e96611e31594ab801ce9d5c6b"
    sha256 x86_64_linux:  "98ebcb577ab3346242635d4ffb7f08d67ba28e7c7c8f7e1e9d1a46f5fc07452a"
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
