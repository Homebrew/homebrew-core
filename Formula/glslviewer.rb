class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.1.2",
      revision: "c6eaf01456db4baa61f876762fdb2d8bf49727e4"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f1f56f94f020e9cbd7687a4050b593c994f88c7171cf9b8844269f274a63b154"
    sha256 cellar: :any,                 arm64_big_sur:  "1cd53a4a542feeb3339d14b6864385431dafde36b4c0c40168932fe1b6ccaddd"
    sha256 cellar: :any,                 monterey:       "60e3894913d8fe9ca335bdce56bcf3500c50980524751dbe091c48a7208cc7c9"
    sha256 cellar: :any,                 big_sur:        "83847db14457a67a4018444b572da153f64faee492cad55bf25fcdd2b7258c30"
    sha256 cellar: :any,                 catalina:       "4193fa09eca8907ea14c05d04a843396c0610cd85af7f483f21242884cc5c6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9871545c27387e50f6f0ca0a36791b1e8c27e47857ad7c1bf457547c15a2b2c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "glfw"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/2D/01_buffers/.", testpath
    pid = fork { exec "#{bin}/glslViewer", "00_ripples.frag", "-l" }
  ensure
    Process.kill("HUP", pid)
  end
end
