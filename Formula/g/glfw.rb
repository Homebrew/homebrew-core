class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.8.tar.gz"
  sha256 "f30f42e05f11e5fc62483e513b0488d5bceeab7d9c5da0ffe2252ad81816c713"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a55abbf4c07fdbc162a913d3ac189d015f39cc81f6b45c1d89cf7d7132f2696"
    sha256 cellar: :any,                 arm64_monterey: "d979c217a8fc5751683d81a282adba61ed04cb7f6849fec877ca6c91738b2f29"
    sha256 cellar: :any,                 arm64_big_sur:  "6cbdaf38af57b2184d5d5fd9100008ebf7ca38920e36c0047b0d10214c806c8c"
    sha256 cellar: :any,                 ventura:        "966162dcdcc2ab70c7d821bce51d5fec9c52b6333d686a3c45a3461464744edd"
    sha256 cellar: :any,                 monterey:       "38ebd6a36fb6197a334f7bafa907470c87d4f1e9a8b12f0901204ce366c896a0"
    sha256 cellar: :any,                 big_sur:        "9fdc214eeb24662a4d7ac08a049d5dc0a48b7dbd31de40e1ee1530e343a9cf2a"
    sha256 cellar: :any,                 catalina:       "7fa08baa7a8e14084d1b2d7a593529c3d38b47fad444af9212b2f37fad83fde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "348b005f5bacae71410ff4ec043a1079edc349e0926332f1a80cb8834079bdfc"
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

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
