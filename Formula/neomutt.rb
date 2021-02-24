class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20210205.tar.gz"
  sha256 "77e177780fc2d8abb475d9cac4342c7e61d53c243f6ce2f9bc86d819fc962cdb"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 arm64_big_sur: "3c35079a979306068a2adf86e73c472149ec8ed2b5a8a19ac40db751a104316f"
    sha256 big_sur:       "f40a3412fef8321567e8572bb015f447f0e81f29c7fc0a9e7f001a26688c1cb3"
    sha256 catalina:      "f1375fe0f878437bb23257363230f5e805956bde9a97979da33c1ec5aa09169c"
    sha256 mojave:        "9cd93e7f86b0da3940852430f1bbd19e07213b966ab1074c55d435953be187eb"
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
