class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  head "https://github.com/nigels-com/glew.git"

  stable do
    url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
    sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"

    patch do
      url "https://github.com/nigels-com/glew/commit/925722f.patch"
      sha256 "6f36179dc42f1bbf5dd5bfe525457e4988749b56ee68180482c3a82b999792ed"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/e7bf0f70.patch"
      sha256 "ccab4b2e2edafe9b96bf277891061dbfb1b0dd0f1de75d574c653d7c49ce9c5c"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/298528cd.patch"
      sha256 "3d9dad811b74ec9502f096393f18f16e4d29891df786ff55d91f4e2301d4d773"
    end
  end

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
