class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftp.gnu.org/gnu/libiconv/libiconv-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/libiconv/libiconv-1.16.tar.gz"
  sha256 "e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "23e9b95c2a691a34dfffef65139708ff6211417a849eee921cb002edc212fcec"
    sha256 cellar: :any, arm64_big_sur:  "5d7976b37516995241432ab9c4cb14a0eba03f2e8af5b7bb110147ce045c9e1f"
    sha256 cellar: :any, monterey:       "012b45c589388c4aec3c8a8124711d12722c561f2ecfe0cfd5a1c14ceb50cd80"
    sha256 cellar: :any, big_sur:        "9253ae6551eb63499fb292b4a65d054c918b93dab8beff0bc12f3290f77bd15c"
    sha256 cellar: :any, catalina:       "24d81638fcd7416a56c3dbdac7e2265d7b0476b17a71b631045425380122e6b1"
    sha256 cellar: :any, mojave:         "7638dd8e2d511a2ce14c6c420762ce7fdbae6a34158e25015c3ffd88de2dd19b"
    sha256 cellar: :any, high_sierra:    "0f7f5728be3b7fc082a62df5e38cf1f1f9dc540e95f0c3479788cc2e2dee7294"
    sha256 cellar: :any, sierra:         "2c40a7b0486b9394f5f4cb6304179527421b68c965c49d961cf2703205da93e1"
  end

  keg_only :provided_by_macos

  depends_on :macos # is not needed on Linux, where iconv.h is provided by glibc

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-utf8mac.diff"
    sha256 "e8128732f22f63b5c656659786d2cf76f1450008f36bcf541285268c66cabeab"
  end

  patch :DATA

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-extra-encodings",
                          "--enable-static",
                          "--docdir=#{doc}"
    system "make", "-f", "Makefile.devel", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    system bin/"iconv", "--help"
  end
end


__END__
diff --git a/lib/flags.h b/lib/flags.h
index d7cda21..4cabcac 100644
--- a/lib/flags.h
+++ b/lib/flags.h
@@ -14,6 +14,7 @@

 #define ei_ascii_oflags (0)
 #define ei_utf8_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
+#define ei_utf8mac_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2be_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
 #define ei_ucs2le_oflags (HAVE_ACCENTS | HAVE_QUOTATION_MARKS | HAVE_HANGUL_JAMO)
