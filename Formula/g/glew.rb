class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.2.0/glew-2.2.0.tgz"
  sha256 "d4fc82893cfb00109578d0a1a2337fb8ca335b3ceccf97b97e5cc7f08e4353e1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nigels-com/glew.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "af7df563c00e50d3ab300d1daba874e67c997b9f18a57581ee69d9d2216d4745"
    sha256 cellar: :any,                 arm64_sequoia:  "4ac8264612c4af3b6864eed07564e14ddf81c25a050aa2bc91953966d12e73e4"
    sha256 cellar: :any,                 arm64_sonoma:   "05aa1fad57b8dd0d68045a54b66ad9d61c494584560a55512a2123d22849e467"
    sha256 cellar: :any,                 arm64_ventura:  "33b1499e0219c3980310dee9e6b115af3ef0324723af7c3a0ff9a68ac7b3e841"
    sha256 cellar: :any,                 arm64_monterey: "a116faecf407ee2a00cb775a3b668fe0f5753ceecd73678d20b3656e6c56d163"
    sha256 cellar: :any,                 arm64_big_sur:  "088dedfcd45fe37b0d027b52bb1c730e01aeacda4d7b00ce14f67a19d1961bce"
    sha256 cellar: :any,                 sonoma:         "b09c9df6478e5d9c3337bffd756f78c2cf6bf5e5de0bf7db8066e8683c2bb3a1"
    sha256 cellar: :any,                 ventura:        "a9850b75eb81c4b3d5f81209fe7a9b3cd848444df83c6a391ff9d77096ba6e58"
    sha256 cellar: :any,                 monterey:       "9d8d8c93eec4287a9231cd0378b45ee3b9735afca387fc1f5def7e2c68533097"
    sha256 cellar: :any,                 big_sur:        "728e40242af0b9a53ae837de3d2658f205e121a04285de29f3964c2dd7512a9d"
    sha256 cellar: :any,                 catalina:       "ee50985ccbbcd0ec1980960b7fb31fce80e99450f14ae02a751a731056182d34"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4299aaba365fcecffb07e5d87bff754833e8e9b7a26ba648691185a97a592fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc36f86706af951931a2c4c905b8b680cf67606406d238fbfd8923f6109e626"
  end

  depends_on "cmake" => [:build, :test]

  on_linux do
    depends_on "freeglut" => :test
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # cmake 4.0 build patch, upstream bug report, https://github.com/nigels-com/glew/issues/432
  patch :DATA

  def install
    system "cmake", "-S", "./build/cmake", "-B", "_build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args(find_framework: "FIRST")
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test_glew)

      set(CMAKE_CXX_STANDARD 11)

      find_package(OpenGL REQUIRED)
      find_package(GLEW REQUIRED)

      add_executable(${PROJECT_NAME} main.cpp)
      target_link_libraries(${PROJECT_NAME} PUBLIC OpenGL::GL GLEW::GLEW)
    CMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <GL/glew.h>

      int main()
      {
        return 0;
      }
    CPP

    system "cmake", ".", "-Wno-dev"
    system "make"

    glut = if OS.mac?
      "GLUT"
    else
      "GL"
    end
    (testpath/"test.c").write <<~C
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
    C
    flags = %W[-L#{lib} -lGLEW]
    if OS.mac?
      flags << "-framework" << "GLUT"
    else
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    # Fails in Linux CI with: freeglut (./test): failed to open display ''
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Tahoe running is headless for now, maybe remove this later
    # ("GLUT Fatal Error: redisplay needed for window 1, but no display callback")
    return if OS.mac? && MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end

__END__
diff --git a/build/cmake/CMakeLists.txt b/build/cmake/CMakeLists.txt
index 419c243..8c66ae2 100644
--- a/build/cmake/CMakeLists.txt
+++ b/build/cmake/CMakeLists.txt
@@ -4,7 +4,7 @@ endif ()

 project (glew C)

-cmake_minimum_required (VERSION 2.8.12)
+cmake_minimum_required (VERSION 3.5)

 include(GNUInstallDirs)
