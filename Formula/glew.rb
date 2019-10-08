class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "8a848d279644c654db3f5a782811a0db9b405d6b6dd49b0ba303b9b8866b0793" => :catalina
    sha256 "a81e04f8be35080991e136e0b2229448fd237a31991d34d5a2e1c5f8db795201" => :mojave
    sha256 "6923b0c452de864a5be7a4d1c47803f434590e9caca1366c57811aead7e5a34b" => :high_sierra
    sha256 "17d6b3bbb956bd1672a26490eb58a82eaa0e3e1adb926f3e87ba060bdf999cf3" => :sierra
    sha256 "7d4cc74d42072da62ef61737bf28b638f52b4f56b2b8234f4709427eb44a11fe" => :el_capitan
    sha256 "a2f2237afc466ec31735d03c983e962240555e7ad32f2bc7b5cbceb996f48ade" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "./cmake", *std_cmake_args
      system "make"
      system "make", "install"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <GL/glew.h>
      #include <GLUT/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-o", "test", "-L#{lib}", "-lGLEW",
           "-framework", "GLUT"
    system "./test"
  end
end
