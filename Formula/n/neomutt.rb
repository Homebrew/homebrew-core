class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230517.tar.gz"
  sha256 "4ac277b40e7ed5d67ba516338e2b26cc6810aa37564f6e9a2d45eb15b3a9213e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "a377ee2883c36d7b44da59c63168771c17ced1cb642106b7fd465327ab78cbd3"
    sha256 arm64_monterey: "3275eab7b93a7672015d3baf4809f273dbb5a366a5ef057b72244bb1592018bf"
    sha256 arm64_big_sur:  "d960fc10feef5540fb53cc003f53e113594e9e84442f46690fa9be836ba538ce"
    sha256 ventura:        "c83efe9f4d5fb7eb1aba7e048d2b86422397e763dc5efab346d8c8f101b0bcd5"
    sha256 monterey:       "c60758b014d4c42ab104e38fe144cd89f8cc15f59a570910a6db421476bd95e1"
    sha256 big_sur:        "75d34c5cd9dc3a862a5d04d5c468b2fa54745419b5e2a96481c0a8e32184525c"
    sha256 x86_64_linux:   "b26f38a24ba54b0c6cdf07d2e69346d263dddf6dec827c7e4541da2c37da5167"
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
