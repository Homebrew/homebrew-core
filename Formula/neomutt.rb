class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180223.tar.gz"
  sha256 "10ba010017cf7db6bb5ac3e2116d6defad56d34be0dceea9d70a66d8510927bb"
  head "https://github.com/neomutt/neomutt.git"

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
    system "./configure", "--enable-gpgme",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--prefix=#{prefix}",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    expected = "debug_level=0"
    output = pipe_output("#{bin}/neomutt -F /dev/null -D -S | grep debug_level", "", 0)
    assert_equal expected, output.chomp
  end
end
