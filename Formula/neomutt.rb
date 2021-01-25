class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20201127.tar.gz"
  sha256 "29ac51a5ac5b4524dfdbb5ac78b59a1cc28c1090c541fb3da7bc86f838ab64cd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "02c44bd0160b8c4118ee6c8c96569b8907b6bf9caa2b4f5de6091eb2a820a896" => :big_sur
    sha256 "a3119427eec30804ee282513555975d22aaa2d959654a59dc0e7e9111014a626" => :arm64_big_sur
    sha256 "291d157a3ca06df36d33f772c5c7e34cf9e30b468d9d7abb9bb232aaad53d415" => :catalina
    sha256 "7e7f2b4645d82958e8ff7f068b50312622a7db16c10e142a25162ad519e1f61b" => :mojave
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
