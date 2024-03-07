class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/refs/tags/3.4.tar.gz"
  sha256 "c038d34200234d071fae9345bc455e4a8f2f544ab60150765d7704e08f3dac01"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6651050d28fe038e7bfd4e8fa1a5693574eaa2d75c91718a8f676efb82dc34b6"
    sha256 cellar: :any,                 arm64_ventura:  "549762dd442f10d30c7d093e6aff9ffdf8ed669979da6441c2ba3cf25c41ca8f"
    sha256 cellar: :any,                 arm64_monterey: "32d34c5cb6a5e02b8af0045e8a9fd4dd505f6c589102ce97eab9a5e40d5dd9f7"
    sha256 cellar: :any,                 sonoma:         "ec625c2a297201e2d71aae74bb688a18ce97039d9838c57d013ae8b9df3632fa"
    sha256 cellar: :any,                 ventura:        "b49affc8b0d66cfa2fe2648cfd959bc94fe7a77426c4aa9e1a9b0dcfc7f2b398"
    sha256 cellar: :any,                 monterey:       "211745327a975a1767ad6110a7150df16526e8f131ca9f1c196591c4d86eb9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635be56f472665900647abe79eeaf8403c194f211c684bf8d62271b9bdf33a9c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
  end

  def install
    args = %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    lib.install "build/src/libglfw3.a"

    args << "-DBUILD_SHARED_LIBS=TRUE"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
