class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "3.0.7",
      revision: "b1a9a41f77c535e58e5dd31a71afa7c24f9d313f"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81067a7d0156aaed4c7efad225a1533d822a9261c3cfaa2df57c9be2d1967ecd"
    sha256 cellar: :any,                 arm64_monterey: "cf33a11e088d40d9d5ae96ed374756c60984cabeb2de33d52af670c091e4a81e"
    sha256 cellar: :any,                 arm64_big_sur:  "67f4455d6abf22ee9bd69b7651f7e4346af09e27afaa3272cd1f9a22cfefce22"
    sha256 cellar: :any,                 ventura:        "5093442e72a18fe1ed34385e9a024f6da103229dcac44d7c916b3cba6af06f7f"
    sha256 cellar: :any,                 monterey:       "c5123fc4e0c8d1d2fb26ab0b2b787d865f1c3301df19b8b2c8d7dd777d5b8c23"
    sha256 cellar: :any,                 big_sur:        "6fcacd65216707ce3ec09c031626cb158cf757d6a59a74ba3b0684f4518dd2be"
    sha256 cellar: :any,                 catalina:       "6bb4be1650a54e23c4c124b229eb01d2b945df3278ba930cd28a667c109cc09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c23e67dd736ed411333a91adbb5cc69e82dd8b017dd394242bf3824f436734"
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
