class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.0.tar.gz"
  sha256 "ecb46be54cfb8a338d2a9b62dec90ec8da6c769078c076f58147d4a6ba1c878d"

  depends_on "qt5" => :build
  depends_on "glew"

  def install
    system "qmake", "-r", "INSTALLDIR=#{prefix}",
      "INCLUDEPATH+=#{HOMEBREW_PREFIX}/include",
      "LIBS+=-L#{HOMEBREW_PREFIX}/lib -lGLEW"

    system "make", "install"
  end

  def patches
    # Patch to make the library install correctly
    DATA
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <opencsg.h>
      class Test : public OpenCSG::Primitive {
        public:
        Test() : OpenCSG::Primitive(OpenCSG::Intersection, 0) {}
        void render() {}
      };
      int main(int argc, char** argv) {
        Test test;
      }
    EOS
    system ENV.cxx, "-framework", "OpenGL", "-lopencsg", testpath/"test.c", "-o", "test"
    system "./test"
  end
end

__END__
diff -ru OpenCSG-1.4.0/opencsg.pro OpenCSG-1.4.0-new/opencsg.pro
--- OpenCSG-1.4.0/opencsg.pro	2016-06-26 20:41:15.000000000 -0400
+++ OpenCSG-1.4.0-new/opencsg.pro	2014-09-15 16:25:33.000000000 -0400
@@ -1,2 +1,2 @@
 TEMPLATE = subdirs
-SUBDIRS  = src example
+SUBDIRS  = src
diff -ru OpenCSG-1.4.0/src/src.pro OpenCSG-1.4.0-new/src/src.pro
--- OpenCSG-1.4.0/src/src.pro	2014-09-15 16:25:33.000000000 -0400
+++ OpenCSG-1.4.0-new/src/src.pro	2016-06-26 20:33:50.000000000 -0400
@@ -2,16 +2,19 @@
 TARGET = opencsg
 VERSION = 1.4.0
 
+isEmpty(INSTALLDIR) {
+  INSTALLDIR = /usr/local
+}
+
 CONFIG += opengl warn_on release
-INCLUDEPATH += ../include ../
+INCLUDEPATH += ../include ../ $$INSTALLDIR/include
 CONFIG -= qt
-LIBS += -lGLEW
+LIBS += -L$$INSTALLDIR/lib -lGLEW
 
 DESTDIR = ../lib
-INSTALLDIR = /usr/local
 headers.files = ../include/opencsg.h
 headers.path = $$INSTALLDIR/include
-target.path = /usr/local/lib
+target.path = $$INSTALLDIR/lib
 INSTALLS += target headers
 
 HEADERS		= ../include/opencsg.h \
