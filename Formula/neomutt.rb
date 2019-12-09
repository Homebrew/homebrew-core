class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20191207.tar.gz"
  sha256 "1618873bd43915d437c5957f19ec2c4ecef6954a5aa647009b98f574ec63410e"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "dab47838900ad77c88c5cb2602dc0fb20d5c760724933c33530dc7f3032b5ee0" => :catalina
    sha256 "65d9c0c6223225f50d233cece618ee097574b7aa6c654a9f4ccf3abc02cdd732" => :mojave
    sha256 "31abacc34dd258a9f629b873ae363e7cb19ffaf5705f4d29ef5ad13b49f4abae" => :high_sierra
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
