class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.10.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd005595d1d94346bb45e9ed0f8f3c83936dcee87d5a1e807f2e47a5960f3472"
    sha256 cellar: :any,                 arm64_monterey: "da13de9b3e3ac334470be3ac8deecd4f8e29de1a2c27d680bc46fb0d1ace4e31"
    sha256 cellar: :any,                 arm64_big_sur:  "0c4dfef79e7c3f27c9b80ffba7ce11f7c06ff201c98d7ad23df01d73a675e204"
    sha256 cellar: :any,                 ventura:        "075f85a29d9be935f0784c815db44ef3a2f903e2f8199497af62051273c3766d"
    sha256 cellar: :any,                 monterey:       "cdbeada12aefbff29f9ce47c175bde59cbbba461e06de73bf778efc2652abb34"
    sha256 cellar: :any,                 big_sur:        "91ef35f3f7112dd78bfae087d32c2fbfa6bd0161064cb232241999570758e416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ed1bb06051af16338321fb98f2e8868832b1163935b6f669f7c06db660c953"
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
    cp_r "#{pkgshare}/examples/io/.", testpath
    pid = fork { exec "#{bin}/glslViewer", "orca.frag", "-l" }
  ensure
    Process.kill("HUP", pid)
  end
end
