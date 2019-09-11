class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180716.tar.gz"
  sha256 "bd89826980b493ba312228c9c14ffe2403e268571aea6008c6dc7ed3848de200"
  revision 2
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "afbda0a165ea2507622a698d3a5260c76f504d677328b409abc459fb014c8bf9" => :mojave
    sha256 "61d3892fbdfbcbb02999791e1f820e53b2dfe8cab2b6f1e9860c6facea6d70bc" => :high_sierra
    sha256 "9e8e8a3bee30aede16711151a74dbf06af36bcda3fb94904ea8f41131388a962" => :sierra
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
    assert_equal "debug_level=0", output.chomp
  end
end
