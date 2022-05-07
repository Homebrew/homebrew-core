class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.0.5",
      revision: "788bb17bfa10759dd88def6979f1d16b31591ff6"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba37631db4d5a5016ca74830b53e1a6145eab92ded213130453d1924ca3904ed"
    sha256 cellar: :any,                 arm64_big_sur:  "c2f3964a3c2411b77aa021ce3add0ba6bbea6e4641edc2aa47624d4e38dbf237"
    sha256 cellar: :any,                 monterey:       "0bdac568dd6be510707ad05908f7e95faf00e7f0b9a6a6471b118927f69550e8"
    sha256 cellar: :any,                 big_sur:        "2f57d314d947c3530bcf83a2018aaa106070e7c13d71828e13cd4173c5d2a1e6"
    sha256 cellar: :any,                 catalina:       "80e0f3fc57a1a15dc78fe50489a95d8a2e658ea784ab388e5e8c821b1f11f164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02fcf7067e5268d82a6fa68eceb3f3dbb7f1a35f7dc709423a3605c67d3a297a"
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
