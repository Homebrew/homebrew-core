class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/27/ngspice-27.tar.gz"
  sha256 "0c08c7d57a2e21cf164496f3237f66f139e0c78e38345fbe295217afaf150695"

  bottle do
    sha256 "f1470393444748a5fb604cdadc7974402753827cca715f1588508fd7305c8d30" => :high_sierra
    sha256 "841be3e66bf1f3dd18a74f2dfd201b95acebfd32e1bd180d99037193e3437bf3" => :sierra
    sha256 "ef9fab04fd5b79cc361fa14642b59d762c7f589ea37c22e41273e97841712537" => :el_capitan
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git"

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
    (testpath/"test.cpp").write <<~EOS
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
