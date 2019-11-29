class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20191129.tar.gz"
  sha256 "c339e17b676d0a9a8db6dd1c9acac3db4b217c6b19050e5a1eec99b1b0b59a2f"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "eb6b23700d5b13a715fc3d31cdf1df8a4f09bc9c63c542bccac05a6dd38d69e3" => :catalina
    sha256 "694902ef8d32f06c824463701fbe4b9c1b3707f22896a2525e4bdd98b7a36540" => :mojave
    sha256 "ea0214b73aa7b52e28c617b3d23c856b62d740758061af2a77492a787f6e316e" => :high_sierra
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
