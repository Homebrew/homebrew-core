class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20191207.tar.gz"
  sha256 "1618873bd43915d437c5957f19ec2c4ecef6954a5aa647009b98f574ec63410e"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "7ed9b6666e46a059d9d92fcc52437bf870ce901e4771ca94b231a09abc4011f0" => :catalina
    sha256 "80ae35db309e042e9673e6ca57667672a8e5ec887d7fe1476c698179c5da8a22" => :mojave
    sha256 "6938e79bb2a74799c87bc30b3b84f223ce6134df07b796f49eea374a333b4504" => :high_sierra
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
