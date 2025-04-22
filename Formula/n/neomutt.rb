class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20250113.tar.gz"
  sha256 "cc7835e80fd72af104a8e146e009e93e687cefbc6c11725ee2ed11d7377486ff"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "c2d9fca146398e3048346e0d6bfaa94c17b1599af64444816618f72b656b590b"
    sha256 arm64_sonoma:  "f8aa3cd0af466823bc6f9e4360885804cb6593c6edd30e5ec49fc92a6231605d"
    sha256 arm64_ventura: "c86fd64152b87d15fa74c3d34cb4633ab0e0fbe80a674f946741f5137c3b21ad"
    sha256 sonoma:        "513e560d739a48b535a2d53c8c5850ed964b798650edcd5bbc2e8d384dbba0f9"
    sha256 ventura:       "0872cb813762014a08dff0077919f750d26b69ba218b53e1b73e69b8d3975e38"
    sha256 arm64_linux:   "b72ade4c63ad7a2c59604e6fc6c61b320bc0d949f18dd3a0d5126b614ce1c334"
    sha256 x86_64_linux:  "184e90d7b007a57450a79489a79b5ab880d4e13bfc21304a24eac1838d618104"
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
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
