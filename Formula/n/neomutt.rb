class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20250510.tar.gz"
  sha256 "12d225e270d8e16cda41d855880b9d938750a4f1d647f55c6353337d32ffd653"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "aeeccca4cdcc5bcfdd187ff32ec295746bd0ff57a92b108a67609917ca6ca96e"
    sha256 arm64_sonoma:  "e7494884f1e9a9289e3993fd0fca9ae0f310d1d30b3886cc95abe0a58bbf18cd"
    sha256 arm64_ventura: "2b2fd04f1c68cb95cca733c59c6892b7e9a91e33583844bcd36327c23ae08ddf"
    sha256 sonoma:        "fe987a4cb6230c846a72b1eb4a7112bbe6699400f349ca3152811a5d7b941999"
    sha256 ventura:       "695b0073f3d0b12d395f8b4c82606d941879ef26c091ce3c29f358a26c1da1bf"
    sha256 arm64_linux:   "6b80fca262c7f3614cb79765ca84c2dc49b0b00ac42262f387939bb5cfad4736"
    sha256 x86_64_linux:  "a04f64ef9d7de760165d6816de3256163f3473d26e4b25967e09a1d1e6f7320f"
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
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level", 1)
    assert_equal "set debug_level = 0", output.chomp
  end
end
