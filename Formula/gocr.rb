class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.51.tar.gz"
  sha256 "6eb2ae0fa4eb07cf4163081e0194ea65f605f7db9709dd30680686804dfc2692"
  revision 1

  bottle do
    cellar :any
    sha256 "8e292594bb5ae676b124f9fc8eab283c855d9f9f37ae9f4cf6c1604ebd2f1058" => :mojave
    sha256 "b5652dd7beb78696522af201f4ce30247efbbdd9f92c949cf45da6b742ee133f" => :high_sierra
    sha256 "a918bc515db9bae30544a958c99f76b7f1fab5889828e4c3c9efe91224c369b6" => :sierra
    sha256 "6f7abd6d0e1d71e456bfef7320cb60f267a3b09881e3eaeada72a99c773a69f3" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system "#{bin}/gocr", "--help"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index bf4181f..883fec2
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -10,7 +10,7 @@ PROGRAM = gocr$(EXEEXT)
 PGMASCLIB = Pgm2asc
 #LIBPGMASCLIB = lib$(PGMASCLIB).a
 # ToDo: need a better pgm2asc.h for lib users 
-#INCLUDEFILES = gocr.h
+INCLUDEFILES = pgm2asc.h output.h list.h unicode.h gocr.h pnm.h
 # avoid german compiler messages
 LANG=C
 
@@ -39,8 +39,8 @@ LIBOBJS=pgm2asc.o \
 #VPATH = @srcdir@
 bindir = @bindir@
 #  lib removed for simplification
-#libdir = @libdir@
-#includedir = @includedir@
+libdir = @libdir@
+includedir = /include/gocr
 
 CC=@CC@
 # lib removed for simplification
@@ -89,7 +89,8 @@ $(PROGRAM): $(LIBOBJS) gocr.o
 	$(CC) -o $@ $(LDFLAGS) gocr.o $(LIBOBJS) $(LIBS)
 	# if test -r $(PROGRAM); then cp $@ ../bin; fi
 
-libs: lib$(PGMASCLIB).a lib$(PGMASCLIB).@PACKAGE_VERSION@.so
+#libs: lib$(PGMASCLIB).a lib$(PGMASCLIB).@PACKAGE_VERSION@.so
+libs: lib$(PGMASCLIB).a
 
 #lib$(PGMASCLIB).@PACKAGE_VERSION@.so: $(LIBOBJS)
 #	$(CC) -fPIC -shared -Wl,-h$@ -o $@ $(LIBOBJS)
@@ -109,17 +110,17 @@ $(LIBOBJS): Makefile
 # PHONY = don't look at file clean, -rm = start rm and ignore errors
 .PHONY : clean proper install uninstall
 install: all
-	#$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir)
-	$(INSTALL) -d $(DESTDIR)$(bindir)
+	$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir)
+	#$(INSTALL) -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGRAM) $(DESTDIR)$(bindir)
 	$(INSTALL) ../bin/gocr.tcl   $(DESTDIR)$(bindir)  # better X11/bin?
 	if test -f lib$(PGMASCLIB).a; then\
 	 $(INSTALL) lib$(PGMASCLIB).a $(DESTDIR)$(libdir);\
 	 $(INSTALL) lib$(PGMASCLIB).@PACKAGE_VERSION@.so $(DESTDIR)$(libdir);\
 	 $(INSTALL) lib$(PGMASCLIB).so $(DESTDIR)$(libdir);\
+	 $(INSTALL) $(INCLUDEFILES) $(DESTDIR)$(includedir);\
+	 $(INSTALL) ../include/config.h $(DESTDIR)$(includedir);\
 	fi
-	# ToDo: not sure that the link will be installed correctly
-	#$(INSTALL) $(INCLUDEFILES) $(DESTDIR)$(includedir)
 
 # directories are not removed
 uninstall:
@@ -129,7 +130,8 @@ uninstall:
 	-rm -f $(DESTDIR)$(libdir)/lib$(PGMASCLIB).@PACKAGE_VERSION@.so
 	-rm -f $(DESTDIR)$(libdir)/lib$(PGMASCLIB).so
 	# ToDo: set to old version.so ?
-	#for X in $(INCLUDEFILES); do rm -f $(DESTDIR)$(includedir)/$$X; done
+	for X in $(INCLUDEFILES); do rm -f $(DESTDIR)$(includedir)/$$X; done
+	-rm -f $(DESTDIR)$(includedir)/config.h
 
 clean:
 	-rm -f *.o *~
