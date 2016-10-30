class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "http://ngspice.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz"
  sha256 "51e230c8b720802d93747bc580c0a29d1fb530f3dd06f213b6a700ca9a4d0108"

  bottle do
    sha256 "08f1356662aa3107b7deb6022242988f20ea14c6784523e2121c799586da6f25" => :sierra
    sha256 "bd587b5908accbd8ba59c679ddcc16486d26ffa93370ce8b4864ef8a695b9cf7" => :el_capitan
    sha256 "5a8245fec0555efb0c569e4072faa5cbd77d138644f293090ecad8a2dd64ac7c" => :yosemite
    sha256 "95eea6b09659ea2098c05ad12dbce4df3bc7cabde606cafbc893758f1ff13b8b" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/ngspice/ngspice"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "libtool" => :build

    # Currently, headers don't get installed to include/*.
    # There is a patch upstream that addresses this for HEAD.
    # Upstream ticket: https://sourceforge.net/p/ngspice/bugs/327
    patch :DATA
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
      "--disable-dependency-tracking", "--with-ngshared", "--enable-cider",
      "--enable-xspice"
    system "make", "install"

    # To avoid rerunning autogen.sh for stable builds, work around the
    # includedir bug by symlinking.  Upstream ticket:
    # https://sourceforge.net/p/ngspice/bugs/327
    include.install_symlink Dir[share/"ngspice/include/*"] if build.stable?
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/src/include/ngspice/Makefile.am b/src/include/ngspice/Makefile.am
index 216816e..fd7fec0 100644
--- a/src/include/ngspice/Makefile.am
+++ b/src/include/ngspice/Makefile.am
@@ -1,11 +1,9 @@
 ## Process this file with automake to produce Makefile.in

-includedir = $(pkgdatadir)/include/ngspice
-
-nodist_include_HEADERS = \
+nodist_pkginclude_HEADERS = \
	config.h

-include_HEADERS = \
+pkginclude_HEADERS = \
	tclspice.h	\
	acdefs.h	\
	bdrydefs.h	\
