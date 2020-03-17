class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.9.tar.gz"
  sha256 "64a16dcdbd08ac3dfcde3b898871e9cfbb604bebfb8d4aa43d68b7ea86aabbf5"

  bottle do
    sha256 "d5f8c24411a2dd107635a254fc423fba9aa201ee73c561b8f76b86378abf46a8" => :catalina
    sha256 "799f5be301b6796eac5c33ce501c8045e80e06c875e9d1a5ea4fa1322ead199d" => :mojave
    sha256 "3b7858b384fc0c1a6c97cb1026b45deadd150c9df76011f0c47637241743d34c" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
