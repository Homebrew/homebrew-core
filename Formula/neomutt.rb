class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230517.tar.gz"
  sha256 "4ac277b40e7ed5d67ba516338e2b26cc6810aa37564f6e9a2d45eb15b3a9213e"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "de341a848e5151fe0df5b4c7e88f352f59b06f934c69d7bf7bd049c23abb328a"
    sha256 arm64_monterey: "8ad66487b3378cd4b8f2302e5c9f2f55d417c233313d1272d74abd30fa5486e4"
    sha256 arm64_big_sur:  "ed9a1f768babc7fd1ddfad6667915bb61aee559ca3cb36258171bbfb2f911b54"
    sha256 ventura:        "aeaa3f3f981d8530b9190471514430c26b020225115cbf84f650c94d4a3277e0"
    sha256 monterey:       "0fad102c41c1011aa73701c163110dfe1490bb0a4b0e7ecd9e57f2e89bbded55"
    sha256 big_sur:        "474c54792e57c0137e7c922eec46290e01fc3fa2aa5cc119b4460486b033f6fb"
    sha256 x86_64_linux:   "9927025da8176230448dc3f97f0909b6b5b2bd0b268533ade8b639c179c3b836"
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
