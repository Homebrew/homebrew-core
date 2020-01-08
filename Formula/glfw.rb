class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.1.tar.gz"
  sha256 "6bca16e69361798817a4b62a5239a77253c29577fcd5d52ae8b85096e514177f"
  head "https://github.com/glfw/glfw.git"

  bottle do
    cellar :any
    sha256 "4996e07913ae48845b920762f8cbeb4c7595d587d9d8b53af267493743e7c10d" => :catalina
    sha256 "788d664fc14aca6ee4072e208930db6c6a8711bdbd6e79cd9f3cc38f69c77a2c" => :mojave
    sha256 "0f222e06e1e48d3f9dfe271df5d1f0c0ae25995151c6900d68e73d9cd39eff8c" => :high_sierra
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
