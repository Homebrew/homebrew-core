class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180323.tar.gz"
  sha256 "4c498424cd6ded946c940f38df7cd01604a23059f258f05d979b2580eafc678b"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "ae2354a645f5602da74cee42e385815ed58730d95138a73ff25200e77d8fdbd5" => :high_sierra
    sha256 "30c9faf7758144c6689ce52e18f14002746889635164f423cb05885b370d637b" => :sierra
    sha256 "92f82210f31bc4667f65bd370750f9ec725535c382084a09771b10b87958ab9d" => :el_capitan
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
