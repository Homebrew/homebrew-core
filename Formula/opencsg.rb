class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.2.tar.gz"
  sha256 "d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb"
  revision 1

  bottle do
    cellar :any
    sha256 "2b07411fdabadd95d0cca10b610937e9c93f67c8c17e166b47ee3d8c1cb136a2" => :mojave
    sha256 "9bbf3895cab4adcea76a072f2ee1b625e82bb4eaa9b5043d34b238ef0142f223" => :high_sierra
    sha256 "18ab9e25f6af26d9f20560d9038b06f18e483e60ff55fcb63acb15e57b51e2eb" => :sierra
    sha256 "1f886dbe08d51e4319b4e2c8a110a0f298e9568c21c15891f2f001f12f8b3155" => :el_capitan
    sha256 "e5487c53392c8d7df4952244ecef3c35ca5b87848af2d30bc8a334fb8e3e9f04" => :yosemite
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
    (testpath/"test.cpp").write <<~EOS
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
