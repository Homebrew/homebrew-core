class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "3.0.4",
      revision: "94e2631e8e94ca4afbecffe06bc7e330e4991fb9"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2dbab6a61e77beffd9b040917d751b4d7b4b5048da89dc273ff2eae67ac1af26"
    sha256 cellar: :any,                 arm64_big_sur:  "853dd8ccceb1d2b0d881343df83690255cb109eb71266bbce6b6b08093229fba"
    sha256 cellar: :any,                 monterey:       "2b94e11dbd10b32b681700ec708f6ff7bbafd20c54f84a88e597013be896888b"
    sha256 cellar: :any,                 big_sur:        "1a94987fdc409a1f7236dad01b65d8ea262b10337d271bd7d997c99a013aa093"
    sha256 cellar: :any,                 catalina:       "2eccee4263263ad60f5f89d23d129184afd8e5dd9eeabebd6246b044ebba3f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b716291ac209723a0768d80e1d905dfc1b81b3ff74d5f2fd5010ff1d2deb700"
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
