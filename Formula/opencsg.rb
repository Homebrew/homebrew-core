class Opencsg < Formula
  desc "Constructive solid geometry rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.2.tar.gz"
  sha256 "d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?OpenCSG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d1bd35e73ad29214d8a5de83a4e0b80385705dbeecce9ed1132afc9eb6c71a61"
    sha256 cellar: :any, arm64_big_sur:  "c06e0c8e9ceee5ad621e6f650a289f34f30428bce43f6a9efb95621fc7afdafb"
    sha256 cellar: :any, monterey:       "f02b160d94f4eb0bbc6fe4381368e8c3151b6b3b1cb20f650121f186f8517b25"
    sha256 cellar: :any, big_sur:        "f7e6296d4466eea7c516fdca9e382d30fad4194b73969a1158d3d399b59c9381"
    sha256 cellar: :any, catalina:       "730e0c7b2656e63ac4c55effbb5030fb737bfdc6ecbda700ed37534ae8b0d295"
    sha256 cellar: :any, mojave:         "7d8c19c4b5c1d26d5f15fb01094977fd58f14ccaa92085a13be68fd27943588a"
  end

  depends_on "qt@5" => :build
  depends_on "glew"

  # This patch disabling building examples
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/990b9bb/opencsg/disable-examples.diff"
    sha256 "12cc799a6352eda4a18706eeefea059d14e23605a627dc12ed2a809f65328d69"
  end

  def install
    qt5 = Formula["qt@5"].opt_prefix
    system "#{qt5}/bin/qmake", "-r", "INSTALLDIR=#{prefix}",
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
    gl_lib = OS.mac? ? ["-framework", "OpenGL"] : ["-lGL"]
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg", *gl_lib
    system "./test"
  end
end
