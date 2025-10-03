class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/refs/tags/3.4.tar.gz"
  sha256 "c038d34200234d071fae9345bc455e4a8f2f544ab60150765d7704e08f3dac01"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "b6f994a80eff1c192e58bde265e72440f065899224dba202d1c2775baf6f46b9"
    sha256 cellar: :any,                 arm64_sequoia: "c81ce0e7ad94a9b1fc06e9e6bb1cb1c03338f093cc2b2d51bf5ee05f704d1dd5"
    sha256 cellar: :any,                 arm64_sonoma:  "e8b219d638bcba7ca5d518cad42cefa577de1a648b583fa59838354554ecf709"
    sha256 cellar: :any,                 arm64_ventura: "3d2030cdf6ab73f5de30be6fc0ce2ef0c4ea4b1757574b1afb4498c5bf50131f"
    sha256 cellar: :any,                 sonoma:        "754e958d4c5c56ca1a93f2fffa99b3e9152b30510dd6d624a2e83cad8824138c"
    sha256 cellar: :any,                 ventura:       "864034d178bafe5885fa656ef00519c38aeab796454d47da5c5e207a1e362ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446bea0d77cbdc446e196247b220750e0a3f5a07083c32c600004103e6bb5e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9db7e9be50b978984167690242f6bdeb30e639ef6f2692b66443dd923fe488"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "build/src/libglfw3.a"

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
