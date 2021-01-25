class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
  sha256 "d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nigels-com/glew.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "9e0b9a17a4d7372d191d377ae63e6bb0070434eefc997299fe708ca12c02bfb5" => :big_sur
    sha256 "4ec7d501b56e5e5682f752975340c57a9aca68431d0d2cc9f849e428860f09de" => :arm64_big_sur
    sha256 "d3113b746275f48d4f50316c9ddf0ce27e7a11e20ffaac33dd1a2aaf9e59d52a" => :catalina
    sha256 "728dbc75cee45763fcc89605d758de1ed950cf219012a1614808a6abd8883ae8" => :mojave
  end

  depends_on "cmake" => [:build, :test]

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

    (testpath/"CMakeLists.txt").write <<~EOS
      project(test_glew)

      find_package(OpenGL REQUIRED)
      find_package(GLEW REQUIRED)

      add_executable(${PROJECT_NAME} main.cpp)
      target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL GLEW::GLEW)
    EOS

    (testpath/"main.cpp").write <<~EOS
      #include <GL/glew.h>

      int main()
      {
        return 0;
      }
    EOS

    system "cmake", ".", "-Wno-dev"
    system "make"
  end
end
