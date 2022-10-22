class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "3.0.4",
      revision: "94e2631e8e94ca4afbecffe06bc7e330e4991fb9"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41d50c9f641d45d86a9b3e2a3eb1b57155c62051f6bc8bc8d6ce90782e824bc5"
    sha256 cellar: :any,                 arm64_big_sur:  "e900679ec548938eebe992e30b5331639cd5502fc837881eb8ceaa423e585999"
    sha256 cellar: :any,                 monterey:       "77271e35821e3b6b6635a4a736339a67bd085965011e4ec640ce77a8b292668c"
    sha256 cellar: :any,                 big_sur:        "aa5968421964aca1ee3d6ed1e8987ac0e4481b01d75a10868eaea106c36c85ff"
    sha256 cellar: :any,                 catalina:       "e60c3494f9637e776086321fcea8d33e8fc982addc8cc2c7bf420be1d00a3c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177718c3a1f493c419648e48344482d3a46feb7b201821ea9a1a07af492f2c98"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glfw"

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
