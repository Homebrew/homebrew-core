class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  head "https://github.com/nigels-com/glew.git"

  stable do
    url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
    sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"

    patch do
      url "https://github.com/nigels-com/glew/commit/925722f91060a0a19acbf1a209cd7b96ed390c19.patch?full_index=1"
      sha256 "d20be5c8dde10eef46f8e8bb46818bd26e49ff9d2d657b7a4a7a478684a8e548"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/e7bf0f70b3b9528764e605794aa868db09ad47f4.patch?full_index=1"
      sha256 "2265dabd566701b991290a0948966ff88ab507452bf67367fb30f3d88c34fe7f"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/298528cd87019fe642a7ce9dfa772b62d7bf6aeb.patch?full_index=1"
      sha256 "d8c75c35f1c7dd0b13991c46e90f1181777696eea6918fc261668cd02bd27727"
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
