class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200821.tar.gz"
  sha256 "4233d03e03220a2ba8096ab28061e12ef538259fd7d32ad441aad5207b17b390"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "ba8e0de6f1b7f21d2ef26afe8d344c3358761c86780d7124fb7954868b816fa4" => :catalina
    sha256 "6b5ed85fed9996f915e9967ba7c64ceed83bfe28c3dcd4f7e86538fc7e3d8021" => :mojave
    sha256 "a945a3d7b91899d817f1eb60b1fb24eff83264a81795b02b3530e820fe6b8b1f" => :high_sierra
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
