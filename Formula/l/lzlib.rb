class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.16.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.16.tar.gz"
  sha256 "203228de911780309dad6813e51541d7ea89469784f01cb661edba080ff1b038"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fa68a434a9f27132be4cc333ce3b4b9c7bb2a4f15748cc55943331100c281d8"
    sha256 cellar: :any,                 arm64_sequoia: "0fdfdd31565885e19fbf88a2eb719871c29bd35f159debce604706fabb1ae292"
    sha256 cellar: :any,                 arm64_sonoma:  "e4cb11bd35c2171dd6341c25849f9da475fdfc52b30aa2e3cd8328930ca9e567"
    sha256 cellar: :any,                 sonoma:        "f96b5fbf7ea10ab92e0753625963e128d7ddde3aba3674a2755d4bd29d8bca53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b7147acf37add8fab2a985f9fa7d36741c29f7207ab472a7e49b81c6d5a0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8fa54474956feacc9818d7fd3a254d494e98f667a0267419c452c5272758e6"
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
