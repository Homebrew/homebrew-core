class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.7.tar.gz"
  sha256 "fd21a5f65bcc0fc3c76e0f8865776e852de09ef6fbc3620e09ce96d2b2807e04"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ee8f78d6379db633345f9d51bdd9924c0392521b09647e5a0db19231222431b"
    sha256 cellar: :any,                 arm64_big_sur:  "05b75b5525eb543cd01deb20ff1fda5e606b62bc15d45e7a5d25c47eb7c7835a"
    sha256 cellar: :any,                 monterey:       "76fa6ed8a21701f59d2d9fc3085f2e4fbd6dab4bf4cf12171ec2e9480fbe3b32"
    sha256 cellar: :any,                 big_sur:        "2c7bf990e4a3c50884748cf8076f5cf7798a62797523f4100f7a8016e47d42d8"
    sha256 cellar: :any,                 catalina:       "6732f2291ca4a5438818dda21411f18f37f14649fa13139f8e26988dbe14076e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d667993dc9496b0beebe0c52e8d9b878a76942e47836ff667bc5111b9abafc1d"
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
