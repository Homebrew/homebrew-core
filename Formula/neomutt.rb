class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200626.tar.gz"
  sha256 "94b2e59667a080cb9d531050c3ad320f9951ba7ba09eb7eda15427899627f89e"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "6da2359c39e751d613589b9e374716ed52c22cf6b28417f84a270d4908884e16" => :catalina
    sha256 "64e3fc2ab551f2cd0cb9b6d00042b8f0227f4db0770ea9c08ccbbe612c8a9974" => :mojave
    sha256 "3743c44f8ac6cd2cb066940e3af3a6b30a0a8c63ca5da1babacfdf6626d79d89" => :high_sierra
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
