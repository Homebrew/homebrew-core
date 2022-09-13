class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  stable do
    url "https://github.com/patriciogonzalezvivo/glslViewer.git",
        tag:      "2.1.2",
        revision: "c6eaf01456db4baa61f876762fdb2d8bf49727e4"

    # Fix error: 'strstr' is not a member of 'std'. Remove in the next release
    patch do
      url "https://github.com/patriciogonzalezvivo/glslViewer/commit/2e517b7cb10a82dc863a250d31040d5b5d021c2a.patch?full_index=1"
      sha256 "fec27080bd7951a061183e8ad09c5f20fa1b74648aa24e400204cd1ac89a8ebc"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f456474a519741116e51b879b003885bb9096b37e9a98deafd2d3d966a541c7"
    sha256 cellar: :any,                 arm64_big_sur:  "a0ddf3807ad7de1c736957ace22843f5aa8c4ab7acd2e543e480c5b7af895712"
    sha256 cellar: :any,                 monterey:       "ea23ee67e1aeff5b957ce19c73ff07c9a774151ff5682bfe1ef3bb8578b4a2fc"
    sha256 cellar: :any,                 big_sur:        "4f7697383e46e1cc11e71011092b74111118e87ccc9a1998524962a5541e47ad"
    sha256 cellar: :any,                 catalina:       "1070b61989a89248aebc4d78b68651e42f71ab2ae68d62960e351b1a7ac7d254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0e575ecbaf09367ca0a22303c57645ade93322c164628972c12db9b1e72a63"
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
