class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20210205.tar.gz"
  sha256 "77e177780fc2d8abb475d9cac4342c7e61d53c243f6ce2f9bc86d819fc962cdb"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 arm64_big_sur: "54f1a6052e8e08f98680c8daad63835220a228db45e9009d67b99c3476f7f19c"
    sha256 big_sur:       "197b3a28aab58386b0b63b3228f55abf9627556cf442a2f780702f56baa9361c"
    sha256 catalina:      "42e30c8b2f846f0e99864dad93adf4e7b697b1364263bc71cd60b32f023efaac"
    sha256 mojave:        "8677ab0e377d6bc4526b8d93d71629f84b52e14b4cdb4620753eef5cac0bc6cd"
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

  uses_from_macos "zlib"

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
