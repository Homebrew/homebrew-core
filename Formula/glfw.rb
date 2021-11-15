class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.5.tar.gz"
  sha256 "32fdb8705784adfe3082f97e0d41e7c515963e977b5a14c467a887cf0da827b5"
  license "Zlib"
  head "https://github.com/glfw/glfw.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f403c7bb3b896a27697b11dadc2ec57dfd0bcdd9677f06506e5b342fd8ef867b"
    sha256 cellar: :any,                 arm64_big_sur:  "a27a303ba0d840adb0b4db81c0c8193b89657eac79d55edc230c41f720af25cd"
    sha256 cellar: :any,                 monterey:       "2b946d54a5c83fae4e45773dece612471fa482881a48e7c92d860e2d352de0ce"
    sha256 cellar: :any,                 big_sur:        "f444562fbb85b074137dabd8074ad783f385e6c50d3dbeaaeb767f31dddc4aab"
    sha256 cellar: :any,                 catalina:       "278dcbbad6f20303f3eb533e45478ee47f3636a240748b2cf2413b5b3c5310e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e54519e99c5f073c35d9b33a43b3fb838982c3d556ac7d0a13e135cef5e80489"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    on_linux do
      # glfw does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
