class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200417.tar.gz"
  sha256 "6ed358053ae17694b580f3b5b13eec9f00f5a7320e76fae6fba767607c40cc48"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "d94a815731036b63fbafd703c9db76e16d242e0217fad9ba4483ee65d37c3dd6" => :catalina
    sha256 "e0b0f137b739258e461e27956866eb37ae787d942f6b82685da5b9f01e880a2b" => :mojave
    sha256 "3423fe201ef33bb8d77644aa40773c9d5d7c93cd4c228a4b52b772d2fcbc5aae" => :high_sierra
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
