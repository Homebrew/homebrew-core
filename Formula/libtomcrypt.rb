class Libtomcrypt < Formula
  desc "Modular and portable cryptographic toolkit"
  homepage "http://www.libtom.org/LibTomCrypt/"
  url "https://github.com/libtom/libtomcrypt/releases/download/1.17/crypt-1.17.tar.bz2"
  mirror "https://distfiles.macports.org/libtomcrypt/crypt-1.17.tar.bz2"
  sha256 "e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116"
  head "https://github.com/libtom/libtomcrypt.git", :branch => "develop"

  depends_on "libtommath"

  # Manual backport of upstream commit here, so it applies to 1.17
  #  https://github.com/libtom/libtomcrypt/commit/62878de0c5dbb9f89474590d953bbdb339bd2f76
  patch :DATA

  def install
    ENV["DESTDIR"] = prefix
    ENV["EXTRALIBS"] = "-ltommath"
    ENV["NODOCS"] = "1"
    ENV["INSTALL_USER"] = `id -un`.chomp
    ENV["INSTALL_GROUP"] = `id -gn`.chomp
    ENV.append "CFLAGS", "-DLTM_DESC -DUSE_LTM"

    system "make"
    system "make", "install"
  end
end

__END__
--- a/src/headers/tomcrypt_macros.h
+++ b/src/headers/tomcrypt_macros.h
@@ -262,21 +262,22 @@

 #ifndef LTC_NO_ROLC

-static inline unsigned ROLc(unsigned word, const int i)
-{
-   asm ("roll %2,%0"
-      :"=r" (word)
-      :"0" (word),"I" (i));
-   return word;
-}
-
-static inline unsigned RORc(unsigned word, const int i)
-{
-   asm ("rorl %2,%0"
-      :"=r" (word)
-      :"0" (word),"I" (i));
-   return word;
-}
+#define ROLc(word,i) ({ \
+   ulong32 __ROLc_tmp = word; \
+   __asm__ ("roll %2, %0" : \
+            "=r" (__ROLc_tmp) : \
+            "0" (__ROLc_tmp), \
+            "I" (i)); \
+            __ROLc_tmp; \
+   })
+#define RORc(word,i) ({ \
+   ulong32 __RORc_tmp = word; \
+   __asm__ ("rorl %2, %0" : \
+            "=r" (__RORc_tmp) : \
+            "0" (__RORc_tmp), \
+            "I" (i)); \
+            __RORc_tmp; \
+   })

 #else

@@ -361,21 +362,22 @@

 #ifndef LTC_NO_ROLC

-static inline unsigned long ROL64c(unsigned long word, const int i)
-{
-   asm("rolq %2,%0"
-      :"=r" (word)
-      :"0" (word),"J" (i));
-   return word;
-}
-
-static inline unsigned long ROR64c(unsigned long word, const int i)
-{
-   asm("rorq %2,%0"
-      :"=r" (word)
-      :"0" (word),"J" (i));
-   return word;
-}
+#define ROL64c(word,i) ({ \
+   ulong64 __ROL64c_tmp = word; \
+   __asm__ ("rolq %2, %0" : \
+            "=r" (__ROL64c_tmp) : \
+            "0" (__ROL64c_tmp), \
+            "J" (i)); \
+            __ROL64c_tmp; \
+   })
+#define ROR64c(word,i) ({ \
+   ulong64 __ROR64c_tmp = word; \
+   __asm__ ("rorq %2, %0" : \
+            "=r" (__ROR64c_tmp) : \
+            "0" (__ROR64c_tmp), \
+            "J" (i)); \
+            __ROR64c_tmp; \
+   })

 #else /* LTC_NO_ROLC */
