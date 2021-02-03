class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.2.tar.gz"
  sha256 "98768e12e615fbe9f3386f5bbfeb91b5a3b45a8c4c77159cef06b1f6ff749537"
  license "Zlib"
  head "https://github.com/glfw/glfw.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2adf2b9b021094d134f027aa5199944ddb0b151e16008bd921e957bacffecd62"
    sha256 cellar: :any, big_sur:       "2d5c251cffe0dca47f83199b0b0fc500b3464888fd244dd6969a055bf2530d8d"
    sha256 cellar: :any, catalina:      "deaf1b20e9fc336d5f0c9a927bc07f2c509fc63538c39e4ab3a024ca7c6170d8"
    sha256 cellar: :any, mojave:        "0c0de277c23273346d703004279d92d17a8962f4d62bf01f76021beea3c3f20a"
    sha256 cellar: :any, high_sierra:   "c6a198383ef979823c1e0071e65771ed9059626071390f2dc5b84b218dc565c3"
  end

  depends_on "cmake" => :build

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
    system "./test"
  end
end
