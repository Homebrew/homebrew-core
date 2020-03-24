class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200320.tar.gz"
  sha256 "69daf2e0633dee7e8bdba74ab714adfa70e8f078028b56d612228c2aa836aafa"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "982e9139ba41152d115acb263e472e185d62fd2ed82a6e269d3a813f2ae25261" => :catalina
    sha256 "ad577d51de14b0c7ba4f833f5677940496da6950762597b0d2189f624af898cf" => :mojave
    sha256 "4f7bae6cff41639f21346b39749aa83f044a76d325295a7ee669b386988dadfc" => :high_sierra
  end

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
                          "--disable-doc",
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
