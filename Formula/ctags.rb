class Ctags < Formula
  desc "Reimplementation of ctags(1)"
  homepage "https://ctags.sourceforge.io/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/ctags/ctags-5.8.tar.gz"
    sha256 "0e44b45dcabe969e0bbbb11e30c246f81abe5d32012db37395eb57d66e9e99c7"

    # also fixes https://sourceforge.net/p/ctags/bugs/312/
    # merged upstream but not yet in stable
    patch :p2 do
      url "https://gist.githubusercontent.com/naegelejd/9a0f3af61954ae5a77e7/raw/16d981a3d99628994ef0f73848b6beffc70b5db8/Ctags%20r782"
      sha256 "26d196a75fa73aae6a9041c1cb91aca2ad9d9c1de8192fce8cdc60e4aaadbcbb"
    end
  end

  bottle do
    rebuild 1
    sha256 "2812884a8f1217767103dc5e0ceb9c7048b5a4d9a34071f76e3c8f9b0f00895c" => :mojave
    sha256 "497e0220e354a9ec7e0735d3ba68a27892f1f69973d6992e36667ea197a236bc" => :high_sierra
    sha256 "56bc233d09bc3591ad1f3a9c5282f9f9cf0729b0d5a0ee001d4ea6f68f2b0ab7" => :sierra
    sha256 "a17ee0cd08909484aeeca9177b356e14655d5f75ecaa4b36a3bd2e2248d8ac91" => :el_capitan
  end

  head do
    url "https://svn.code.sf.net/p/ctags/code/trunk"
    depends_on "autoconf" => :build
  end

  # fixes https://sourceforge.net/p/ctags/bugs/312/
  patch :p2, :DATA

  def install
    if build.head?
      system "autoheader"
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Under some circumstances, emacs and ctags can conflict. By default,
      emacs provides an executable `ctags` that would conflict with the
      executable of the same name that ctags provides. To prevent this,
      Homebrew removes the emacs `ctags` and its manpage before linking.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system "#{bin}/ctags", "-R", "."
    assert_match /func.*test\.c/, File.read("tags")
  end
end

__END__
diff -ur a/ctags-5.8/read.c b/ctags-5.8/read.c
--- a/ctags-5.8/read.c	2009-07-04 17:29:02.000000000 +1200
+++ b/ctags-5.8/read.c	2012-11-04 16:19:27.000000000 +1300
@@ -18,7 +18,6 @@
 #include <string.h>
 #include <ctype.h>
 
-#define FILE_WRITE
 #include "read.h"
 #include "debug.h"
 #include "entry.h"
diff -ur a/ctags-5.8/read.h b/ctags-5.8/read.h
--- a/ctags-5.8/read.h	2008-04-30 13:45:57.000000000 +1200
+++ b/ctags-5.8/read.h	2012-11-04 16:19:18.000000000 +1300
@@ -11,12 +11,6 @@
 #ifndef _READ_H
 #define _READ_H
 
-#if defined(FILE_WRITE) || defined(VAXC)
-# define CONST_FILE
-#else
-# define CONST_FILE const
-#endif
-
 /*
 *   INCLUDE FILES
 */
@@ -95,7 +89,7 @@
 /*
 *   GLOBAL VARIABLES
 */
-extern CONST_FILE inputFile File;
+extern inputFile File;
 
 /*
 *   FUNCTION PROTOTYPES
--- a/ctags-5.8/general.h	2007-05-02 23:21:08.000000000 -0400
+++ b/ctags-5.8/general.h	2019-07-18 19:09:43.000000000 -0400
@@ -56,7 +56,7 @@
 /*  This is a helpful internal feature of later versions (> 2.7) of GCC
  *  to prevent warnings about unused variables.
  */
-#if (__GNUC__ > 2  ||  (__GNUC__ == 2  &&  __GNUC_MINOR__ >= 7)) && !defined (__GNUG__)
+#if 0
 # define __unused__  __attribute__((unused))
 # define __printf__(s,f)  __attribute__((format (printf, s, f)))
 #else
