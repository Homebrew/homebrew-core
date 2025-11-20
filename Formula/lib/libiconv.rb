class Libiconv < Formula
  desc "Conversion library"
  homepage "https://www.gnu.org/software/libiconv/"
  url "https://ftpmirror.gnu.org/gnu/libiconv/libiconv-1.18.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libiconv/libiconv-1.18.tar.gz"
  sha256 "3b08f5f4f9b4eb82f151a7040bfd6fe6c6fb922efe4b1659c66ea933276965e8"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a61991512d58131934103c9ca06ece31c6219c0fe30efb9cba93dbc95edea18"
    sha256 cellar: :any, arm64_sequoia: "9e1ae85546acf11cfebe7552c70808a9b19418229726501f2bb7b3bceee47966"
    sha256 cellar: :any, arm64_sonoma:  "3f75b595baa51417a65a1fc7e3f9dc3bace9e14b40d03a6b5814342f5ee9f89e"
    sha256 cellar: :any, arm64_ventura: "aa195231486c152454575759ec79d6b48b3aa3deab8ee37c0d19e99f98573eb5"
    sha256 cellar: :any, sonoma:        "9b5c0480b3c407b6b629e0f18f9e6888319c45fd6d9a87f1443b4baea9aa7577"
    sha256 cellar: :any, ventura:       "6b53c95ddaf694117513b040836eeddfe8eb7c0b16f687ea5784cbfdc6a78ff9"
  end

  keg_only :provided_by_macos

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :macos # is not needed on Linux, where iconv.h is provided by glibc

  uses_from_macos "gperf"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/9be2793af/libiconv/patch-utf8mac.diff"
    sha256 "e8128732f22f63b5c656659786d2cf76f1450008f36bcf541285268c66cabeab"
  end

  patch :DATA

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
