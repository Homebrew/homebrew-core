class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.3.1/glew-2.3.1.tgz"
  sha256 "b64790f94b926acd7e8f84c5d6000a86cb43967bd1e688b03089079799c9e889"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/nigels-com/glew.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6fa553d6cf43a6eab23005df9e38bd5b2f6597534f1e1cc53b9ffe7a0398e9d4"
    sha256 cellar: :any, arm64_tahoe:       "41a7f57c0f003d4ec7e042fde179cad2cadd504418db453a9738df775214a608"
    sha256 cellar: :any, arm64_sequoia:     "db97decd397b3df69d9c00ebedf0442bb756fc0da6d10c029c51a8779deb2bb6"
    sha256 cellar: :any, arm64_linux:       "6dc8bbe25f8e5eb5272225677c055ec3fa2ad525dbb616985c6b3471690b33bd"
    sha256 cellar: :any, x86_64_linux:      "88b1451b62ed6c211dbebfa36d6e3f21e975f13e96c9351c83d637a462423457"
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
  patch do
    url "https://github.com/nigels-com/glew/commit/a7c9cc7c01fa9d59322edf702b6d59e10fe427cb.patch?full_index=1"
    sha256 "d177dc99fb81d310d2b78b051cdddb4432843904806952794040f8201d702c0c"
    type :backport
    resolves "https://github.com/nigels-com/glew/pull/455"
  end

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DOPENGL_glx_LIBRARY=#{formula_opt_lib("mesa")}/libGL.so" if OS.linux?
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

    system "cmake", "-S", ".", "-B", "build", "-Wno-author"
    system "cmake", "--build", "build"

    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <GL/glew.h>
      #ifdef __APPLE__
      #include <OpenGL/OpenGL.h>
      #else
      #include <GL/glut.h>
      #endif

      int main(int argc, char** argv) {
        #ifdef __APPLE__
        CGLPixelFormatAttribute attributes[] = {kCGLPFAAllowOfflineRenderers, 0};
        CGLPixelFormatObj format;
        CGLContextObj context;
        GLint count;
        assert(CGLChoosePixelFormat(attributes, &format, &count) == kCGLNoError);
        assert(format);
        assert(CGLCreateContext(format, NULL, &context) == kCGLNoError);
        CGLDestroyPixelFormat(format);
        assert(CGLSetCurrentContext(context) == kCGLNoError);
        #else
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        #endif
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        #ifdef __APPLE__
        CGLSetCurrentContext(NULL);
        CGLDestroyContext(context);
        #endif
        return 0;
      }
    C
    flags = %W[-L#{lib} -lGLEW]
    if OS.mac?
      flags << "-framework" << "OpenGL"
    else
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    if OS.linux? && ENV.exclude?("DISPLAY")
      system formula_opt_bin("xorg-server")/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
