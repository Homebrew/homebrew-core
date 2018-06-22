class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180622.tar.gz"
  sha256 "9289ef61668c4eee39a85fb593f4afcb520a90d7840609fd922444b05dedf399"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "ad9361596e2f46c43be76aebb6012d58af54f1763fc5cde5d0cec0239eff393f" => :high_sierra
    sha256 "daab3475b46e6ca13f42b2f800da6f1ca30e0031c2464399a4d0a83249e2f823" => :sierra
    sha256 "e38850ef503965b110d30b4e22653f5da05ab245a734ebc4ad658130b23cc6b8" => :el_capitan
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "notmuch"
  depends_on "openssl"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
