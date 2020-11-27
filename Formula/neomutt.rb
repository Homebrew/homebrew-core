class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20201127.tar.gz"
  sha256 "29ac51a5ac5b4524dfdbb5ac78b59a1cc28c1090c541fb3da7bc86f838ab64cd"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "95751693f3db390b039e0051f81b0d93a828219632c5dc7f73270d6023581c2d" => :big_sur
    sha256 "62fe4c4eb74ac893df26d8261a37cf79087125564f656c3f188174dcc070adb9" => :catalina
    sha256 "1acc6a05c446cd34608fec368037fe44744fa12b1fd1361e6be84ba348c4ebf3" => :mojave
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
