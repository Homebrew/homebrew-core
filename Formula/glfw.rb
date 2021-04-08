class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.4.tar.gz"
  sha256 "cc8ac1d024a0de5fd6f68c4133af77e1918261396319c24fd697775a6bc93b63"
  license "Zlib"
  head "https://github.com/glfw/glfw.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f64dee7187b644ba98c6009890a5761d575516a10e055de2c75bb7c88e1ffdb"
    sha256 cellar: :any, big_sur:       "68cf1e73ab3d2f826847607a07b7204a317c696ff635d0789d35b52df3dfe8dd"
    sha256 cellar: :any, catalina:      "8d87eeccf2a8376c8e29fbc46f0d47e02738b5f999ab8aeacdd148d53c6d15bc"
    sha256 cellar: :any, mojave:        "f2fe8dcb33b5dd0a53d5d05fe609bf270206c51e37d7a996bbb2a2089b6de2fd"
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

    on_linux do
      # glfw does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
