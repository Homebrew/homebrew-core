class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.6.tar.gz"
  sha256 "ed07b90e334dcd39903e6288d90fa1ae0cf2d2119fec516cf743a0a404527c02"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8f155b434f74ac11c303fab7887b5b41b2ea6440f438e101172b2b0a813ca004"
    sha256 cellar: :any,                 arm64_big_sur:  "dca3eaac840e35f4e56f57a0825b557e932fcdc1bc9963b98fa18bf90c0af647"
    sha256 cellar: :any,                 monterey:       "0eca3ff0166f1ece7deceb367e65b4edfbca79796b39675c6cb5e97e062908c2"
    sha256 cellar: :any,                 big_sur:        "9cbe17a177731240a8fc404aa28610f9377001e6b22c0d9824f06ba7079a6177"
    sha256 cellar: :any,                 catalina:       "843ed388610abf58783e081e47974eaa000cd67a1146b5795df6e17fba4c2062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f4bed83bf9ff81bb0bb0d78b35b07c6405777e5ad82b9e8e73606ab4f24677"
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
