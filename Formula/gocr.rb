class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.51.tar.gz"
  sha256 "6eb2ae0fa4eb07cf4163081e0194ea65f605f7db9709dd30680686804dfc2692"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e87b2dfc0833449b09d6b0129b53b6c02d92949d414783a630d4e074734c309" => :mojave
    sha256 "9130f859261ff352e24fc1dc17c5b7c73eae89d4387cbf35bd2fbdfdfbac62d5" => :high_sierra
    sha256 "45dd1209a1a24c9d63c8817eab5be77690be2c0a2ca1e26c71954c3dbaaeeff2" => :sierra
    sha256 "46a821f9815ad964bc58feff3e5344964e9c164db625c9a8faffc0c7450055fb" => :el_capitan
  end

  option "with-lib", "Install library and headers"

  depends_on "netpbm" => :optional
  depends_on "jpeg" => :optional

  # Edit makefile to install libs per developer documentation
  patch :DATA if build.with? "lib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs" if build.with? "lib"
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
