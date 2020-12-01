class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20201127.tar.gz"
  sha256 "29ac51a5ac5b4524dfdbb5ac78b59a1cc28c1090c541fb3da7bc86f838ab64cd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "76c9f219dd1f8be9a4fbe40d36715052e53bb90b0fcfb10da2c01f4846f4e0d0" => :big_sur
    sha256 "e3f851ed976608c203faf45e0986164151d43ed4337ab6e624c13b5bfce580cd" => :catalina
    sha256 "549494de04024944f598577502dfdbe5292e4bcf452305d5e04a8a3a47735766" => :mojave
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
