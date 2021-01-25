class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.2.tar.gz"
  sha256 "d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb"
  revision 2

  bottle do
    cellar :any
    sha256 "2d663b21cd90f37d02e772426aba83c7f9e9451a8325a2caf99f926a2176a495" => :big_sur
    sha256 "441628c8cb74c7bf2eb12999c0d6befd2f94e11597c6707df86512eed2efefa2" => :arm64_big_sur
    sha256 "d42c4c0c8aa5ef5abbe1f260e98f2652b0e7f78563415219b6b8c80fc4aa5859" => :catalina
    sha256 "41ca5a9f643f81e0c9ad862e5386994d85aed57c8c9b6a34493d97f7e66e7a53" => :mojave
    sha256 "67d059404b3a950b73ac4ab6096727c90f24fc1309871969c0d46a7df429de5b" => :high_sierra
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
