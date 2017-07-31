class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ca64d2e470aec2b8c222f1ecaacff6480fb5325d983da3a287b81ebf8939bb68" => :sierra
    sha256 "5e426e5b18242c93b582b6fc8edeea976465d581924d0cd1c7cc52748fc0aa96" => :el_capitan
    sha256 "357ac59b6b0bfe6bee5d754b7b0e8b48f7a049123a5c4afd8c197996bcd2e658" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
