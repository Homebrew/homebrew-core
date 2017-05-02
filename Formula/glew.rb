class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
  sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "6d1af9d3f60da8c423fb1723c631abd784335b81cd8cda606fb0d30240dbae3a" => :sierra
    sha256 "200ab3d519d234bf9a34b223faa07c1ace46eeda197b9352e1b6dc0a67846b4b" => :el_capitan
    sha256 "6f2809e99ea25d6d33280921b5cd50e148800228450c34043d8ce11ac8f7e32c" => :yosemite
    sha256 "2b72bd7d59343ae64eaa87fd69f806759ac356a77300bb6b6a6ab40247384dc2" => :mavericks
  end

  depends_on "cmake" => :build

  patch do
    url "https://github.com/nigels-com/glew/commit/925722f.patch"
    sha256 "6f36179dc42f1bbf5dd5bfe525457e4988749b56ee68180482c3a82b999792ed"
  end

  patch do
    url "https://github.com/nigels-com/glew/pull/143.patch"
    sha256 "7761252b504e869e66edfe1615b8eef40311b9eebd6268ae164d4c83af1b31e0"
  end

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
