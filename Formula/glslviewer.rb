class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.0.4",
      revision: "bdf448011d8d0e0b227b193554e9193661b80a68"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "507cecd87cad646318c0edadb20089cb9a90e84093c8beb4e592b46ab03911a7"
    sha256 cellar: :any,                 arm64_big_sur:  "c67d574a03f04ae0d671122c3c85d3b9f32a9362afae58de40393e2dea9c63f9"
    sha256 cellar: :any,                 monterey:       "f9156ade0f34dc58861e9df43378a31b2aecbb39acf698a5a977c7c9afd0ec03"
    sha256 cellar: :any,                 big_sur:        "61d12134b9b897b8f785e49e384afd8c09061d15639083a9371b98b2b24bb9ee"
    sha256 cellar: :any,                 catalina:       "5618f975dfe446b23493d1aa3f7c87288c01c48c978b759f355255aacb388406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a67a20f3f87feb3758105f7e8a4a2cc272124300642096ed513436ecb07661a5"
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
