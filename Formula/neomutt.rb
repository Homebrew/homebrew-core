class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200821.tar.gz"
  sha256 "4233d03e03220a2ba8096ab28061e12ef538259fd7d32ad441aad5207b17b390"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "bf9c46984df7825ca6465e251e05ed65ce86000919b1de3a0a2a7fec1f13e9a0" => :catalina
    sha256 "74e8c0f59d647e706ae0a11233f561c05dd6318fa949e09122329d14634bd076" => :mojave
    sha256 "c934bb5efe0cd0c335d4b5900cb4f376e06c5bcfcf806135add973e792349c2e" => :high_sierra
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
