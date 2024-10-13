class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/"
  url "https://web.archive.org/web/20150915000000/www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_sequoia:  "ac1682fd11e3bc9f5bb6ceefdcd060057aa066ebd58e95195c9bcfd4cffb1826"
    sha256                               arm64_sonoma:   "c831cf8f33a699f5176df7115c4d0918133782a78b610bae3a1d6952af562649"
    sha256                               arm64_ventura:  "40b16905a4cdbe254c41f5cec691b7363b8fefc543226fb5d0ca5f1b073510ed"
    sha256                               arm64_monterey: "8567f1d743b65f76bfebc80dc8a27e4604b283a07ee5e11ffd1173227c683946"
    sha256                               arm64_big_sur:  "b96a459a6aa0f11cb8d498c71ab902b1b2bdd75bdf02aa5233366171f61d750a"
    sha256                               sonoma:         "898372e2a6fa6867a4d69adc65b40b8f0defdbf81ba0f8c60dbd4d0134034958"
    sha256                               ventura:        "1dbe3c32dcbada980502a6494084c34579d045e38bc475fa43c37b727f7905cd"
    sha256                               monterey:       "a40e16aafef0932b323eaf35dc4dab2f969b8f9174ec8d73b1942908cf4b603c"
    sha256                               big_sur:        "0fea290739e05216d0ecc36266ba774cd27f70cf022c13b94b56e509a66bc44d"
    sha256                               catalina:       "74f154bdfaabb2819bfab9969a88addff7e0b08cca3aafe3ea13805fa588e68d"
    sha256                               mojave:         "491aa872d9c617f7d323aa368498f25728d25bbdf1e60fde272e62b149831c99"
    sha256                               high_sierra:    "90a79ade2abcd36772eb50db1c93298a67766d626a5316a3eeb1638312fbd377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16aa28d4dfb99fbffc482973e91282d1b7a4986f3cdc2638805228962143d949"
  end

  deprecate! date: "2024-07-02", because: :repo_removed

  uses_from_macos "ncurses"

  on_linux do
    depends_on "gzip"
  end

  # See https://github.com/Homebrew/homebrew-core/pull/53085.
  # Further issues regarding missing headers reported upstream to nrt@ff.iij4u.or.jp
  patch :DATA

  def install
    # Work around for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    if OS.mac?
      # zcat doesn't handle gzip'd data on OSX.
      # Reported upstream to nrt@ff.iij4u.or.jp
      inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'
    end

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end

  test do
    system bin/"lv", "-V"
  end
end

__END__
--- a/src/escape.c
+++ b/src/escape.c
@@ -62,6 +62,10 @@
 	break;
     } while( 'm' != ch );
 
+    if( 'K' == ch ){
+        return TRUE;
+    }
+
     SIDX = index;
 
     if( 'm' != ch ){
--- a/src/guess.c
+++ b/src/guess.c
@@ -21,7 +21,7 @@
  */

 #include <stdio.h>
-
+#include <string.h>
 #include <import.h>
 #include <decode.h>
 #include <big5.h>
--- a/src/guesslocale.c
+++ b/src/guesslocale.c
@@ -24,6 +24,7 @@

 #include <stdlib.h>
 #include <string.h>
+#include <ctype.h>
 #include <locale.h>
 #if defined(HAVE_LANGINFO_CODESET)
 #include <langinfo.h>
