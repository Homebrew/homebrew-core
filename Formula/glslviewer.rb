class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "3.0.1",
      revision: "d816b5d7ab6c9d1a0b1007b8a27c24a1e330b76b"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9bf045ba8f252a3ef1726f552d6c24d22a2be1a597e2ec9fc88fe5c8eff82220"
    sha256 cellar: :any,                 arm64_big_sur:  "a11e7256ec826ae2435507ec781428cbec9fe8d50d432a98574161818f484ebb"
    sha256 cellar: :any,                 monterey:       "9fb99a18f9a4775b8c43dd5c9f5f82c5aad905c94433e1ea543ce7ee23f543f3"
    sha256 cellar: :any,                 big_sur:        "56bbbe0b32e5dd91e345014e8b73c76026bf0b8bc555d079630f4363e790eabf"
    sha256 cellar: :any,                 catalina:       "25cee349f8ff580d3ebff976df4625893523de07cc9b747df103064195d318b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d510cb49e1b3094d24d919a82cf1b614e40688c7401754d3fbd33d2d13d37352"
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
