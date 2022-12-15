class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.1.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "421c84b4e4fd9b6941922c4a0ce536cd19b8ee09eaeb736976ec5b09c356c925"
    sha256 cellar: :any,                 arm64_monterey: "fc69dc5b243e0ebaf534c8577a92f60392e017edd9733fec84d079545bf93d18"
    sha256 cellar: :any,                 arm64_big_sur:  "689396195e735373e157a8a3c167f2a68069e090574a9d80011cf721e79eda25"
    sha256 cellar: :any,                 ventura:        "bce35154a04ba6e988272b7c8faee45fcd09790b88b662d0fa81785ce309798d"
    sha256 cellar: :any,                 monterey:       "d69b49162105747437712bd045d433a2ba05a493e456d389e73a138d9c72a8e6"
    sha256 cellar: :any,                 big_sur:        "8c3c68e24f17d9a930be4c620739890560a1e8dbc2ed04dc718978fd3e7a4d15"
    sha256 cellar: :any,                 catalina:       "cfd3b93ec996e2278d477647eae3a303c2bd21f6b9d7958e95d6bbbd6d713915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0266debcdc9d6b9ac6af5c7ee2d211ca78ef779dbf22047e35d5284c2e0e6d"
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
