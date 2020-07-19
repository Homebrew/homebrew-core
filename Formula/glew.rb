class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3181853e5ec2d8e0b24842c06b2882fce2d3ff89d83f4647bfee755005e165ca" => :catalina
    sha256 "04ad309f33a1355e3e29251cf60ad24058b53443352c74d30624ec470b0428a1" => :mojave
    sha256 "1b5e8d521625cfabd6e429e4111d74cd68fdc4efbde826a6b5bbee1a7261e801" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "root", :because => "root ships its own copy of glew"

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
