class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.15.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.15.tar.gz"
  sha256 "4afab907a46d5a7d14e927a1080c3f4d7e3ca5a0f9aea81747d8fed0292377ff"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fffdea895f5b64466a14d6642d73fece994c792b7bf8ee75be9cc5c178eb177a"
    sha256 cellar: :any,                 arm64_sequoia: "d37d282c89b456e608a8870d3cbba0dd210230d39929b0834fee066a925f9603"
    sha256 cellar: :any,                 arm64_sonoma:  "e4d1233198674a8dc0f135a26b3d3b2104b44c024b2f8a87f7a62f5f67685a03"
    sha256 cellar: :any,                 sonoma:        "e25b6fcd40cd2a97d0b36e0cd5557c4b30c66dd1a95685d20f7497252bcd9d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b370fbc07e1840563b7e65c23aabc942918ce7c98242a79d1ff37497731eafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1fd813a8c33dd6a678184271f8eecc2075d522611827e0c9cb5b2190950cb3c"
  end

  on_macos do
    # Change shared library name and flags for macOS
    patch :DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llz", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 4f99874..8e344d9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -28,17 +28,16 @@ lib : $(libname_static) $(libname_shared)
 lib$(libname).a : lzlib.o
 	$(AR) $(ARFLAGS) $@ $<
 
-lib$(libname).so.$(soversion) : lzlib_sh.o
-	$(CC) $(CFLAGS) $(LDFLAGS) -fpic -fPIC -shared -Wl,--soname=$@ -o $@ $< || \
-	$(CC) $(CFLAGS) $(LDFLAGS) -fpic -fPIC -shared -o $@ $<
+lib$(libname).$(soversion).dylib : lzlib_sh.o
+	$(CC) $(CFLAGS) $(LDFLAGS) -fpic -fPIC -dynamiclib -install_name $(libdir)/$@ -compatibility_version $(soversion) -current_version $(pkgversion) -o $@ $<
 
 bin : $(progname_static) $(progname_shared)
 
 $(progname) : $(objs) lib$(libname).a
 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(objs) lib$(libname).a
 
-$(progname)_shared : $(objs) lib$(libname).so.$(soversion)
-	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(objs) lib$(libname).so.$(soversion)
+$(progname)_shared : $(objs) lib$(libname).$(soversion).dylib
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(objs) lib$(libname).$(soversion).dylib
 
 bbexample : bbexample.o lib$(libname).a
 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ bbexample.o lib$(libname).a
@@ -115,15 +114,13 @@ install-lib : lib
 	  $(INSTALL_DATA) ./lib$(libname).a "$(DESTDIR)$(libdir)/lib$(libname).a" ; \
 	fi
 	if [ -n "$(libname_shared)" ] ; then \
-	  if [ -e "$(DESTDIR)$(libdir)/lib$(libname).so.$(soversion)" ] ; then \
+	  if true; then \
 	    run_ldconfig=no ; \
 	  else run_ldconfig=yes ; \
 	  fi ; \
-	  rm -f "$(DESTDIR)$(libdir)/lib$(libname).so" ; \
-	  rm -f "$(DESTDIR)$(libdir)/lib$(libname).so.$(soversion)" ; \
-	  $(INSTALL_SO) ./lib$(libname).so.$(soversion) "$(DESTDIR)$(libdir)/lib$(libname).so.$(pkgversion)" ; \
-	  cd "$(DESTDIR)$(libdir)" && ln -s lib$(libname).so.$(pkgversion) lib$(libname).so ; \
-	  cd "$(DESTDIR)$(libdir)" && ln -s lib$(libname).so.$(pkgversion) lib$(libname).so.$(soversion) ; \
+	  $(INSTALL_SO) ./lib$(libname).$(soversion).dylib "$(DESTDIR)$(libdir)/lib$(libname).$(pkgversion).dylib" ; \
+	  cd "$(DESTDIR)$(libdir)" && ln -s lib$(libname).$(pkgversion).dylib lib$(libname).dylib ; \
+	  cd "$(DESTDIR)$(libdir)" && ln -s lib$(libname).$(pkgversion).dylib lib$(libname).$(soversion).dylib ; \
 	  if [ "${disable_ldconfig}" != yes ] && [ $${run_ldconfig} = yes ] && \
 	     [ -x "$(LDCONFIG)" ] ; then "$(LDCONFIG)" -n "$(DESTDIR)$(libdir)" || true ; fi ; \
 	fi
diff --git a/configure b/configure
index 90ab72d..e843746 100755
--- a/configure
+++ b/configure
@@ -123,7 +123,7 @@ while [ $# != 0 ] ; do
 		progname_shared=${progname}_shared
 		progname_lzip=${progname}_shared ;;
 	--enable-shared)
-		libname_shared=lib${libname}.so.${soversion}
+		libname_shared=lib${libname}.${soversion}.dylib
 		progname_shared=${progname}_shared
 		progname_lzip=${progname}_shared ;;
 	--disable-ldconfig) disable_ldconfig=yes ;;
