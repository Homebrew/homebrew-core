class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "3.0.6",
      revision: "758ff9c194c87f4b54dfe5c1f4f340b15b9bb206"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2baa38e7243b880de37e7ff965d0466f42954f7e81700a55b868bed2d301236"
    sha256 cellar: :any,                 arm64_big_sur:  "c87cb1de017cd1109212eeb45c5d2d8919f9b02e028368acad59334e048396f0"
    sha256 cellar: :any,                 monterey:       "d0a4b54bf588b733fe570c611073bcc0794fa7078d62a744ea67d11a5ed10825"
    sha256 cellar: :any,                 big_sur:        "6f7c3b0b02864b4e3f6c818bd5c3a5398446ba863b345dd72be4d2fcdf02a168"
    sha256 cellar: :any,                 catalina:       "9d0c816ae69d730a7974bac6fc3dfeeff80f2bfbdce46ec66dc4de5271a37e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0733a10aa75446c57e4c20fd8c136ede354c0b9d1aefa0035658dfb0340521b"
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
