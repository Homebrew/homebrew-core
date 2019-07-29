class Libnids < Formula
  desc "Implements E-component of network intrusion detection system"
  homepage "https://libnids.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz"
  sha256 "314b4793e0902fbf1fdb7fb659af37a3c1306ed1aad5d1c84de6c931b351d359"
  revision 1

  bottle do
    cellar :any
    sha256 "d42b4d49f5b6e4b465cbed83337adcc218d32c99c754b89b249d8f2c675a02f9" => :mojave
    sha256 "35f886a96ce255259d1cef139939cf760f3fc3b3b35664f9a59e9a8bdf27f072" => :high_sierra
    sha256 "b0ab2ca7fe6339f9ce06b6916e6205792a62b123e3887f7e372a9ed3a6ce85ed" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libnet"

  # Patch fixes -soname and .so shared library issues. Unreported.
  patch :DATA

  def install
    # autoreconf the old 2005 era code for sanity.
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}",
                          "--enable-shared"
    system "make", "install"
  end
end

__END__
--- a/src/Makefile.in	2010-03-01 13:13:17.000000000 -0800
+++ b/src/Makefile.in	2012-09-19 09:48:23.000000000 -0700
@@ -13,7 +13,7 @@
 libdir		= @libdir@
 mandir		= @mandir@
 LIBSTATIC      = libnids.a
-LIBSHARED      = libnids.so.1.24
+LIBSHARED      = libnids.1.24.dylib
 
 CC		= @CC@
 CFLAGS		= @CFLAGS@ -DLIBNET_VER=@LIBNET_VER@ -DHAVE_ICMPHDR=@ICMPHEADER@ -DHAVE_TCP_STATES=@TCPSTATES@ -DHAVE_BSD_UDPHDR=@HAVE_BSD_UDPHDR@
@@ -65,7 +65,7 @@
 	ar -cr $@ $(OBJS)
 	$(RANLIB) $@
 $(LIBSHARED): $(OBJS_SHARED)
-	$(CC) -shared -Wl,-soname,$(LIBSHARED) -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
+	$(CC) -dynamiclib -Wl,-dylib -Wl,-install_name,$(LIBSHARED) -Wl,-headerpad_max_install_names -o $(LIBSHARED) $(OBJS_SHARED) $(LIBS) $(LNETLIB) $(PCAPLIB)
 
 _install install: $(LIBSTATIC)
 	../mkinstalldirs $(install_prefix)$(libdir)
@@ -76,7 +76,7 @@
 	$(INSTALL) -c -m 644 libnids.3 $(install_prefix)$(mandir)/man3
 _installshared installshared: install $(LIBSHARED)
 	$(INSTALL) -c -m 755 $(LIBSHARED) $(install_prefix)$(libdir)
-	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.so
+	ln -s -f $(LIBSHARED) $(install_prefix)$(libdir)/libnids.dylib
  
 clean:
 	rm -f *.o *~ $(LIBSTATIC) $(LIBSHARED)
