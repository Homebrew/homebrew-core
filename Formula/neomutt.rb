class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200501.tar.gz"
  sha256 "9d0a0da14448ebb60f2585532fc4cd903c10146903c8639cd0a3d51fe620430f"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "bb70e1dfafdc5e0ea6799b1f53e6940fba36773f5b50dbea58e6d30ad0ac8131" => :catalina
    sha256 "6dc8c4e0305bc76cf4480684f0dec4c1c355da3993c9498f3cad8519c85002bf" => :mojave
    sha256 "908e70961047ae7d943bb43bb86a618bfa34915da431df1892cb001c40a3c6c0" => :high_sierra
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
