class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20171215.tar.gz"
  sha256 "7fb76e99a9f23715ad772ad8f7008c6e2db05eed344817055176c76dbd60c1b5"
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
    system bin/"neomutt", "-D"
  end
end
