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

  patch do
    url "https://raw.githubusercontent.com/openscad/homebrew-tap/master/patches/opencsg.diff"
    sha256 "9d710cf6c2d5495ca5ba51c0319785cefc21477c85fa3aacb9ccd3473fee54f3"
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
