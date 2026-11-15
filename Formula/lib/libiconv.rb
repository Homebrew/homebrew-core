class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftpmirror.gnu.org/libiconv/libiconv-1.19.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libiconv/libiconv-1.19.1.tar.gz"
  sha256 "9a06844846d664d7122161700c10a64480d7c7bcead3091925a785b38c91edab"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "84718608d5c5f2bf0afd3884587957f9d1c5a4870340dcdc75c12d3a5fd71007"
    sha256 cellar: :any, arm64_tahoe:       "9a7174efb9791b8465d71485e9d455ce51de5be13a6c20ae457ca2c63f06d7d0"
    sha256 cellar: :any, arm64_sequoia:     "eaecd1468193e943ad6fb51c286d5bba93ed425c391370be6a9e498ce7f45b92"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :macos # is not needed on Linux, where iconv.h is provided by glibc

  uses_from_macos "gperf"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-utf8mac.diff"
    sha256 "e8128732f22f63b5c656659786d2cf76f1450008f36bcf541285268c66cabeab"
    type :unofficial
  end

  patch :DATA

  deny_network_access!

  def install
    ENV.deparallelize

    # Reported at https://savannah.gnu.org/bugs/index.php?66170
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
      --enable-extra-encodings
      --enable-static
      --docdir=#{doc}
    ]
    system "./configure", *args, *std_configure_args

    make_args = %W[
      CFLAGS=#{ENV.cflags}
      CC=#{ENV.cc}
      ACLOCAL=aclocal
      AUTOMAKE=automake
    ]
    system "make", "-f", "Makefile.devel", *make_args
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
