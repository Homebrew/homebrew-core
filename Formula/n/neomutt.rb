class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260501.tar.gz"
  sha256 "1c261b3bff6e67e5b46c1de0bd9dbfcb14ace9fc5e49d910582db7bc280616bd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3443bee6f0ecad425e4e96a88e56a840f81f0ea51b37aeb541a4622354e93290"
    sha256 arm64_sequoia: "d3d7684c19f9a4ccaf59373026d7557e1d58885aba092d818f1a789dd92a85fe"
    sha256 arm64_sonoma:  "a45e60a745416456fdb30d59fdbf1b38b1304caf300b253464a9c6ef8f6962de"
    sha256 sonoma:        "89f90d143a74ab764d8ea02eee280563acfb5ff78ac3794f787d6a67c5565b60"
    sha256 arm64_linux:   "427dbb135581eb3223d22e293edeed6a81e1a8adced0a10c5cb06272cc4e2e25"
    sha256 x86_64_linux:  "c386e1cccd8b765f2247d315baaa4b0bc356ceb7b92c93733c23443d2577a210"
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
