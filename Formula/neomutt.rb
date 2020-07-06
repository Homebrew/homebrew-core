class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200626.tar.gz"
  sha256 "94b2e59667a080cb9d531050c3ad320f9951ba7ba09eb7eda15427899627f89e"
  license "GPL-2.0"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "d1f6edf36d492185a4f8fa35296c9176862641939bef9335d00773c69359b242" => :catalina
    sha256 "03ca3d480c10bc301cd37b58d88700129d747be4250333b10654280af6602b8b" => :mojave
    sha256 "d7834ff5bcf0b475d2794e8b83ec16de4e4ba25981afc98a78143b3cd7696e18" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--with-gpgme=#{Formula["gpgme"].opt_prefix}",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-ui=ncurses",
                          "--lua",
                          "--with-lua=#{Formula["lua"].prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
