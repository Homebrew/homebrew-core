class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"

  bottle do
    sha256 "95b64e844560f948bdd487f1aa8a36fa6b54af18a278be1793b2f34614e08736" => :catalina
    sha256 "92fac64ac02e38e225184831bda82521c4136d480660d52f599c6a92f6647860" => :mojave
    sha256 "62cf9605edbaf21775ddc788367d78260d79058fba8c90674620d1ee59c9b273" => :high_sierra
    sha256 "50be9b91b5158ce882207622b6a2581185f67a5c999c8f1105d522d800344a37" => :sierra
    sha256 "f9648fc0bbf530759a8cd7057ebed5310c3b293c5cd2c1e284aef28f55e44ba7" => :el_capitan
    sha256 "6ccb57a3f549935b58b3aaa56b0a49b5a7fc41692594d2e4a0d718a5be30fa84" => :yosemite
  end

  depends_on "autoconf" => :build

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0, :DATA

  def install
    ENV.deparallelize

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system "#{bin}/hspell", "-l", "test.txt"
  end
end
__END__
diff --git Makefile.in Makefile.in
index a400ca1..fa595e8 100644
--- Makefile.in
+++ Makefile.in
@@ -98,7 +98,7 @@ clean:
	      hebrew.wgz.lingsizes.tmp dmask.c \
	      spell-he.xpi he.dic he.aff README-he.txt \
	      README_he_IL.txt he_IL.dic he_IL.aff he_IL.zip \
-	      specfilter.o specfilter he.rws libhspell.so.0 libhspell.so \
+	      specfilter.o specfilter he.rws libhspell.dylib \
	      dict_radix.lo gimatria.lo corlist.lo libhspell.lo linginfo.lo \
	      he.xpi misc/dictionaries/he.dic misc/dictionaries/he.aff \
	      misc/dictionaries/license.txt misc/dictionaries/README-he.txt
@@ -137,9 +137,8 @@ install: all
	test -d $(DESTDIR)$(INCLUDEDIR) || mkdir -m 755 -p $(DESTDIR)$(INCLUDEDIR)
	cp hspell.h linginfo.h $(DESTDIR)$(INCLUDEDIR)/
	chmod 644 $(DESTDIR)$(INCLUDEDIR)/hspell.h $(DESTDIR)$(INCLUDEDIR)/linginfo.h
-	test -f libhspell.so.0 && cp libhspell.so.0 $(DESTDIR)$(LIBDIR)/
-	test -f libhspell.so.0 && chmod 755 $(DESTDIR)$(LIBDIR)/libhspell.so.0
-	test -f libhspell.so.0 && ln -sf libhspell.so.0 $(DESTDIR)$(LIBDIR)/libhspell.so
+	test -f libhspell.dylib && cp libhspell.dylib $(DESTDIR)$(LIBDIR)/
+	test -f libhspell.dylib && chmod 755 $(DESTDIR)$(LIBDIR)/libhspell.dylib


 ################################################
@@ -194,9 +193,8 @@ libhspell.a: $(LIBOBJS)
	-ranlib $@

 # For building a shared library (--enable-shared)
-libhspell.so.0: $(LIBOBJS:.o=.lo)
-	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -shared -Wl,-soname,libhspell.so.0 $^ -lz
-	ln -sf libhspell.so.0 libhspell.so
+libhspell.dylib: $(LIBOBJS:.o=.lo)
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ -dynamiclib $^ -lz

 HSPELL_LIB = @HSPELL_LIB@
 $(HSPELL_EXECUTABLE): hspell.o tclHash.o $(HSPELL_LIB)
diff --git configure.in configure.in
index 6081cff..061fa68 100644
--- configure.in
+++ configure.in
@@ -112,7 +112,7 @@ AC_ARG_ENABLE([shared],
 if test x$ac_opt_shared = xyes
 then
	AC_MSG_NOTICE([Shared library building enabled.])
-	HSPELL_LIB="libhspell.so.0"
+	HSPELL_LIB="libhspell.dylib"
 else
	AC_MSG_NOTICE([Shared library building disabled.])
	HSPELL_LIB="libhspell.a"
