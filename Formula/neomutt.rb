class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20191102.tar.gz"
  sha256 "2feffde535323a5c96b8b2c895af2a32c46d25dc9d2e45ffc2d9ffaa06f73468"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "4124e566fd88d9bfd10b8cfc9519b66a6b179c2f7c1351b752958277a2f3328f" => :catalina
    sha256 "483e6a823fe1987a11cdb5b2b48ac469c87f7afa372b4deecb1c4211c56a9517" => :mojave
    sha256 "c6f891c2289fe009c266c53c71b327f227c9f3bd11908945035be8587e880a3a" => :high_sierra
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
