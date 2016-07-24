class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.0.tar.gz"
  sha256 "ecb46be54cfb8a338d2a9b62dec90ec8da6c769078c076f58147d4a6ba1c878d"
  revision 1

  bottle do
    cellar :any
    sha256 "577e6777db3c9ee1010577e9dd29f7d86cff106273ef650bf58b08b20020a751" => :el_capitan
    sha256 "d6e5913457b310b32a3dd9673a248793fd53bc6d2863f55b3d3334be7665c544" => :yosemite
    sha256 "26098d8c2d4e89f2a0389c470f8b094a805e97c959defa3381ab0cd8c8d8ec9e" => :mavericks
  end

  depends_on "qt5" => :build
  depends_on "glew"

  # This patch adds support for specifying INSTALLDIR
  # It has been submitted upstream and accepted 20160709, through private email
  # (as that's how submissions are done)
  # Should be in the next release (> 1.4.0)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/814a29d3ce4c6e7e919cd2fcd64bf45d421e821b/opencsg/patch-build.diff"
    sha256 "9d710cf6c2d5495ca5ba51c0319785cefc21477c85fa3aacb9ccd3473fee54f3"
  end

  def install
    system "qmake", "-r", "INSTALLDIR=#{prefix}",
      "INCLUDEPATH+=#{Formula["glew"].opt_include}",
      "LIBS+=-L#{Formula["glew"].opt_lib} -lGLEW"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg",
           "-framework", "OpenGL"
    system "./test"
  end
end
