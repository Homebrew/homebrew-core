class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
  sha256 "d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nigels-com/glew.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "17420ea2fddc60d424c2113aa9f452603763cacabcf4447457781c9dc974bf78"
    sha256 cellar: :any,                 arm64_big_sur:  "ff3928527b5eca567f758adaec4674495baf760b974e624d06a6e4f9f0540db1"
    sha256 cellar: :any,                 monterey:       "17e8c8fcc77d132b1d47c47ba5bb3a22a84088aa6c06ec890bf8a8463f363ffc"
    sha256 cellar: :any,                 big_sur:        "c96cbd58749e9e19359058823ef06c2b4b3b621e4751e4970dbc649d6e0f6bae"
    sha256 cellar: :any,                 catalina:       "4afe7a78fbe20c553a42d30e6b14f7696c3636bab810d2907b8843d583c115f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bad4a1bacddec065a38c9ccb6c87dd5423c554aed6ac1b187fe8164b071267e"
  end

  depends_on "cmake" => [:build, :test]

  on_linux do
    depends_on "freeglut" => :test
    depends_on "mesa-glu"
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
    (testpath/"CMakeLists.txt").write <<~EOS
      project(test_glew)

      set(CMAKE_CXX_STANDARD 11)

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

    glut = "GLUT"
    on_linux do
      glut = "GL"
    end
    (testpath/"test.c").write <<~EOS
      #include <GL/glew.h>
      #include <#{glut}/glut.h>

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
    flags = %W[-L#{lib} -lGLEW]
    on_macos do
      flags << "-framework" << "GLUT"
    end
    on_linux do
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    on_linux do
      # Fails in Linux CI with: freeglut (./test): failed to open display ''
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end
    system "./test"
  end
end
