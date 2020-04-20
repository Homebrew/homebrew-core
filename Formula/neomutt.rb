# neomutt: rebuild bottle
class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200417.tar.gz"
  sha256 "6ed358053ae17694b580f3b5b13eec9f00f5a7320e76fae6fba767607c40cc48"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    rebuild 1
    sha256 "d1eeee164ecbaf38af7d38592417498f12e13bdf8c0e300f6c4dea0caa58fcdf" => :catalina
    sha256 "d9d1e5fee63f622664cc5fc7f863d3beed9bbf9aa38f259d5448609025acf202" => :mojave
    sha256 "16cd4e655bf901f83cfdf5c91119ffdabaac87e105c41412141b55c56b943dab" => :high_sierra
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
