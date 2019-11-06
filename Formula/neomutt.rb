class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20191102.tar.gz"
  sha256 "2feffde535323a5c96b8b2c895af2a32c46d25dc9d2e45ffc2d9ffaa06f73468"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "fbe4287622f85ea13acaab9532ec85ab08dd82f83f0de1ecb4badf457dfa97c8" => :catalina
    sha256 "a15866ed959a8cf440b3858a4e0fc0a008032ae060e738f79a2eb07fb8586e99" => :mojave
    sha256 "1662e7dd021efd8318573f9c76b2f1c2f6c71553fc32dccbd1ae6ebec3a689fb" => :high_sierra
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
    assert_equal "set debug_level = 0", output.chomp
  end
end
