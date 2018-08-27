class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180716.tar.gz"
  sha256 "bd89826980b493ba312228c9c14ffe2403e268571aea6008c6dc7ed3848de200"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "a6b1860ba4b48441468139da5d1dd3b17beef51797281eac8f7060317b114c43" => :mojave
    sha256 "c7ae26b5c57241beb1cd32b878840935441f2655d4eb774d7ea381c4846f771c" => :high_sierra
    sha256 "2bf5f6453b264880744c695a544e6f0c81dcea750dd1695039032557373cf2e1" => :sierra
    sha256 "b72ed1a178545bed52a3436c86c9339a0727f7653519ed91da95be43b2a402a7" => :el_capitan
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
