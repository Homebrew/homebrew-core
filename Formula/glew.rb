class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
  sha256 "d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1"
  license "BSD-3-Clause"
  head "https://github.com/nigels-com/glew.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "5f130b7557c1753c3880fc2eb16363de05a9d5a7d032294e8f8e744583df467f" => :catalina
    sha256 "dc1e74289200e3c1db6792f085f1216529b491fc463bc6205bcd40807a4dba31" => :mojave
    sha256 "1e2d9d489808104dfa3a4dab5662e200e1020b40b869bac45b6b84b8490cd936" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "root", because: "root ships its own copy of glew"

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
