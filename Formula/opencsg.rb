class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.0.tar.gz"
  sha256 "ecb46be54cfb8a338d2a9b62dec90ec8da6c769078c076f58147d4a6ba1c878d"

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
