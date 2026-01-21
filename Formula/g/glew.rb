class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.3.0/glew-2.3.0.tgz"
  sha256 "b261a06dfc8b970e0a1974488530e58dd2390acf68acb05b45235cd6fb17a086"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nigels-com/glew.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20ceac578d8d66661d5c65047ffddb4148ab236cb9e07f67462a46362aeafa95"
    sha256 cellar: :any,                 arm64_sequoia: "19159872e52e5f03c4c83c772d8a388955bcf1cb3745cde6a07ea4395acf8bda"
    sha256 cellar: :any,                 arm64_sonoma:  "33565abbfae16cbf1662f006df2254930506d09f23782b14f39b4704809d6938"
    sha256 cellar: :any,                 sonoma:        "a20e82f3d6e66aeb6c178ed2aa2f331e915d6fff73e3e54df83f46629954fd1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1a4a8e64c51a9941d374dff39d952da8b93e0ce1ef2e4c2dd0df1ad00d9f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920af8d79b6b8c1db8c05084b92e9eff12d177254edff62fd235b29f71c9f0de"
  end

  depends_on "cmake" => [:build, :test]

  on_linux do
    depends_on "freeglut" => :test
    depends_on "xorg-server" => :test
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # OpenGL extension fixes.
  # Upstream PR ref: https://github.com/nigels-com/glew/pull/455
  patch do
    url "https://github.com/nigels-com/glew/commit/a7c9cc7c01fa9d59322edf702b6d59e10fe427cb.patch?full_index=1"
    sha256 "d177dc99fb81d310d2b78b051cdddb4432843904806952794040f8201d702c0c"
  end

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DOPENGL_glx_LIBRARY=#{Formula["mesa"].opt_lib}/libGL.so" if OS.linux?
    system "cmake", "-S", "./build/cmake", "-B", "_build", *args,
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
    # Tahoe running is headless for now, maybe remove this later
    # ("GLUT Fatal Error: redisplay needed for window 1, but no display callback")
    return if OS.mac? && MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

    if OS.linux? && ENV.exclude?("DISPLAY")
      system Formula["xorg-server"].bin/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
