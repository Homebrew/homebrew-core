class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180716.tar.gz"
  sha256 "bd89826980b493ba312228c9c14ffe2403e268571aea6008c6dc7ed3848de200"
  revision 2
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "e4cf9f442f87c2092a5721d7d9e0f8832b645fda68c01a779a45f2bec6cd403c" => :mojave
    sha256 "757e4871abd3a6f474a84f8ea9c541a14557ad3263f597779b11caa428cfcd5d" => :high_sierra
    sha256 "0e0e9c5a2abb6c6e379ab2823180ed3eb695e24654d3ab368cf9c8c5524bb1bd" => :sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
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
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
