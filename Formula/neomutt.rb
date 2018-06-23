class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180622.tar.gz"
  sha256 "9289ef61668c4eee39a85fb593f4afcb520a90d7840609fd922444b05dedf399"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "67fd9ac2acccbe318b55e256702445395833c56d1cdb75209968e50f0a209553" => :high_sierra
    sha256 "7b1e82f03a67dddabee534f64df10857a63c32f7aaf3c6487c2a2c6cf26110de" => :sierra
    sha256 "ff66a94c12a5db12ec5b2882c2aa4e97be63238041206b108f7f011ef1b13d81" => :el_capitan
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "notmuch"
  depends_on "openssl"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
