class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230407.tar.gz"
  sha256 "9c1167984337d136368fbca56be8c04a550060a2fdd33c96538910ea13ba6d4f"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "5d1d75187c259fe4736cae143fa000716260e5a371f8cf768631157883d977aa"
    sha256 arm64_monterey: "86c587c0dec446c9d808087c90d017f19ab0b0880e040707969aefeae55d0637"
    sha256 arm64_big_sur:  "28c466ffe01de9f7f56a8b5308282e8a29fbe68f2fa767c8fabcf3eb99f464e4"
    sha256 ventura:        "ae7c3cb919267cdeec06fc0343a239b6ba315e9ff8db949ddbd4c1a076518dbe"
    sha256 monterey:       "f190f82b685d2b957825c0de0a11e8fe9aec81437664fa5008763e28949d358e"
    sha256 big_sur:        "e65b85fb0d87bd7ccd2c2225d8f0aad786b92b62943e3f3c9c83067e8041edfd"
    sha256 x86_64_linux:   "fdc45ba2883a200404e01e73150b7441a2de7333ef90e7bf2e97d2b54b26e9a0"
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

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
