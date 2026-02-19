class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.3.1/glew-2.3.1.tgz"
  sha256 "b64790f94b926acd7e8f84c5d6000a86cb43967bd1e688b03089079799c9e889"
  license "BSD-3-Clause"
  head "https://github.com/nigels-com/glew.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ec85f5ae1b523fe8b30ccd462b1f7988693f0f7b87660b12d08ecf575a1cf01"
    sha256 cellar: :any,                 arm64_sequoia: "7cec448d9e7413bea9130a398f7ebdec896c0148f37dc69302b95f5079c0f2f1"
    sha256 cellar: :any,                 arm64_sonoma:  "7f3110639abd423d4fe61c34b6f33bb8b859141e22ad3c32337f36508f9865c7"
    sha256 cellar: :any,                 sonoma:        "a6ae467e7998dfc0f8b237f01118194c9aed50bc5f769cc2c10d116d14accdde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72762b76d9023594c8e7c35404458a7ab43b169116d73545d46b892a83314552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f24c5184a070eb8500a8def5fa6b5bf4bb8b531fc305f0aa4cd71cc3fb5af6"
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
