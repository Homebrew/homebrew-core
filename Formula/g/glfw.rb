class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/refs/tags/3.4.tar.gz"
  sha256 "c038d34200234d071fae9345bc455e4a8f2f544ab60150765d7704e08f3dac01"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "f76d85e284182f2ad8b5d98e34bbd2b124a71fb65741305f3ec32860cd39fa62"
    sha256 cellar: :any,                 arm64_sonoma:   "f4339af5fb5faa3df804bf54d30eaeb70e5eb09136433a7dd12a9a4c4f7891a0"
    sha256 cellar: :any,                 arm64_ventura:  "3dc29608d2a685d2a89dabcf2c636952aa65d64801af10ab54d848da66115fc2"
    sha256 cellar: :any,                 arm64_monterey: "a3069efe74c2d3f563db176c0c0ed30f7a22ab144674ce6e4406b13b291ee700"
    sha256 cellar: :any,                 sonoma:         "f62736f5f8d62fe9e3eefc97b9629f93e6d5513fe970449d56e1379bf17e6ce0"
    sha256 cellar: :any,                 ventura:        "4c2dda8866485758ea1bf446ffd09d99aab8874e3fc3b6f6f968ca8d80ef3344"
    sha256 cellar: :any,                 monterey:       "fbeb82f1e016c9b2acbf51acedcbd3b70f98006a6793c5946466ecaa78dde94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707c1b8a6dc5362e2e00ba631aad8dd85c5d44d8ef721fd7c65cb68f3b9192f1"
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
