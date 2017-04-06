class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.2.tar.gz"
  sha256 "d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb"

  bottle do
    cellar :any
    sha256 "075e67cb712c3d0ffd8b20bc2f510cc1a06a42cfabf1048f7ba21867320c8222" => :sierra
    sha256 "075e67cb712c3d0ffd8b20bc2f510cc1a06a42cfabf1048f7ba21867320c8222" => :el_capitan
    sha256 "d95e4f314bf0b2184d6b5133861d6ad85caf0285273ab1bd8b9e42fc01fbbce3" => :yosemite
  end

  depends_on "qt" => :build
  depends_on "glew"

  # This patch disabling building examples
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/990b9bb/opencsg/disable-examples.diff"
    sha256 "12cc799a6352eda4a18706eeefea059d14e23605a627dc12ed2a809f65328d69"
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
