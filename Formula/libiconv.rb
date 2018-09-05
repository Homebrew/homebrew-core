class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftp.gnu.org/gnu/libiconv/libiconv-1.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/libiconv/libiconv-1.15.tar.gz"
  sha256 "ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178"

  bottle do
    cellar :any
    sha256 "e6e824f8f346ff3199168aca022fe0dae9f00a1d8d3ecba5fb855a9b29767588" => :mojave
    sha256 "2e16b57017ea3f5c34a57ea7fe39f2aa22db73452eb438d67eb43a4ba8d5bc9d" => :high_sierra
    sha256 "53766c5e51bc8e63b0e4c03bae4bcd22d414882eb484a4b55cb3ebe735e20a09" => :sierra
    sha256 "1b7a98758ed53e484768a99cfdd0941bad8393ffce23d0f9650bbeff945da1f0" => :el_capitan
    sha256 "19eb1ef341c6f45c08347bfb8d24e50d666a269523753862fa9a7a62691c0199" => :yosemite
  end

  keg_only :provided_by_macos

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
