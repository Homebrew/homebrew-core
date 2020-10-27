class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200925.tar.gz"
  sha256 "dcec98ea2454d7695ff92184c33a0051c2b3c46320f81f7889c4580c943140dd"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "bb9829de2249a318f926a8f435ece8731f1534c58fb0256ca34409bbb22c42fe" => :catalina
    sha256 "79dff03b1a3485f63c0d2affd5327d70246e72707a0c66830ff871a591bb8300" => :mojave
    sha256 "a5fb829bdcf7cdc5925339fe37bdcdfbd1f4fdbb9d000b73592fe75c5d00ee53" => :high_sierra
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
