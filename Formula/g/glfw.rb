class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/refs/tags/3.5.1.tar.gz"
  sha256 "5234f4f29473e9a06bc7847d8371858dd135d38466eeeaa652fdc9f8f9ff0c20"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bf700c2e1cb05182b6b401ddd589546a93668bd901d2edfd6e8248dbae62444d"
    sha256 cellar: :any, arm64_sequoia: "2d107dd9ea7fdd5c9bf4735a52f0946a2e6cdfaf0bcd848bf1472381eb67345d"
    sha256 cellar: :any, arm64_sonoma:  "65cc605791bd069b89564f6b73a36fd3d30484eb1cf5d6f954a52fb739b8b33c"
    sha256 cellar: :any, sonoma:        "3306cc0376bd16767d497691ab2a2f8a8943ae1d924e8212c871a5d9e8524b2d"
    sha256 cellar: :any, arm64_linux:   "3878e2f4e581f18dae91675f3dcb7bfc7bb417ee71deb2c3c6fe8b5d81291cbf"
    sha256 cellar: :any, x86_64_linux:  "ae2a8267fa04a8fc917f993da6f5ea0c7b323ba92634c75f2f155529d856fb15"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "xorg-server" => :test
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxinerama"
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

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lglfw"
    if OS.linux? && ENV.exclude?("DISPLAY")
      system Formula["xorg-server"].bin/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
