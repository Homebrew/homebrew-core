class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz"
  mirror "https://ftpmirror.gnu.org/libiconv/libiconv-1.17.tar.gz"
  sha256 "8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "2621f09f8681897e86d452876e64f73156042713db36beb52c95074f648c3ee6"
    sha256 cellar: :any, arm64_big_sur:  "c79ae70f794ef2747b10d0aa7c4ab27435a742509ec17131902f1d075002e043"
    sha256 cellar: :any, monterey:       "9484d4d80192da3c0dfd8d3eaa8b391db0120dd7d259670b821a38de7f404539"
    sha256 cellar: :any, big_sur:        "a68939ed416afc78c2d9ece02bab394858783db5e03e3cd4575f66dc9a43160f"
    sha256 cellar: :any, catalina:       "dfb536db610c9b2bad0e62d114ea81852d6d97da68b1360a404b9eb452413ab5"
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
