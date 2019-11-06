class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.tar.gz"
  sha256 "81bf5fde487676a8af55cb317830703086bb534c53968d71936e7b48ee5a0f3e"
  head "https://github.com/glfw/glfw.git"

  bottle do
    cellar :any
    sha256 "59d76959deeaed390dd2f2a98e670f1a944c26d1212ce9dd8bd230f5010eec44" => :catalina
    sha256 "5f7f80b2113be000ab11c52357d2b1dc684b82a61455c562c2d84968fab2b2c7" => :mojave
    sha256 "d064f1a5ed0ac3d2cc2979472f47116c4aa4dcabe5a2b8f6684411e157bf0ef6" => :high_sierra
    sha256 "bf7f440724924b206abe7be4407df6277cf7c145c25eb9429d20d2d4ccd0994e" => :sierra
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
