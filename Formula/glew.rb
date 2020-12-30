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
    sha256 "acb605dfd8d291689743df3b4302428b610ca96f1321aa1ecdddf88621b53730" => :big_sur
    sha256 "b8477a96b184ca2f3f30131ce59f9efc2b0867ef386045b547b82a98553d0c91" => :arm64_big_sur
    sha256 "5f130b7557c1753c3880fc2eb16363de05a9d5a7d032294e8f8e744583df467f" => :catalina
    sha256 "dc1e74289200e3c1db6792f085f1216529b491fc463bc6205bcd40807a4dba31" => :mojave
    sha256 "1e2d9d489808104dfa3a4dab5662e200e1020b40b869bac45b6b84b8490cd936" => :high_sierra
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
