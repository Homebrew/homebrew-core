class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180512.tar.gz"
  sha256 "fe573b9b6944c2d40d42e6ab62b711e9980da2d2bc36c533e0ba322fd9f3b851"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "0991f61890f9670810bdc1c9904da76ff3ff8a0e5cfa263f13547c6900900764" => :high_sierra
    sha256 "ddbdfbf1d5e8d63c5ca057c43658967218d551f3ecdfa5d95e9f32c6b523baf8" => :sierra
    sha256 "1ab6181ecf9bb6146384a9f4cbce1bf067a1815c776fc27dcc1c047c2f73e8fe" => :el_capitan
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
