class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
    tag:      "3.5.2",
    revision: "edb58380ba8523d32e72966d0d0508ba78c28ffd"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef4a5d219028d7ea4a08bf1a050e3c67f20c78a24eebe767b740528868659cfb"
    sha256 cellar: :any, arm64_sequoia: "95ed442adc21687a48ea4013dc18894dd52969bc67278275f406bc153cb2fe18"
    sha256 cellar: :any, arm64_sonoma:  "b25427a43b2278f8c59d649c692d6e95d9fd9955b8ff2cce72e7f11bb6a6e1b1"
    sha256 cellar: :any, sonoma:        "2e59c5551318183fbecf74205826837c759bbd7a6f1bfa366fa7ed2b89b852f0"
    sha256 cellar: :any, arm64_linux:   "42508b4a7db0c548b63214c56007ef10b14da631632f6c8873486004be6e3905"
    sha256 cellar: :any, x86_64_linux:  "044cdd2f70fed82506cb21b420e1898f582519049aa03cb6e198a41bca222b71"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "glfw"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/io/.", testpath
    pid = spawn bin/"glslViewer", "orca.frag", "-l"
    sleep 1
  ensure
    Process.kill("HUP", pid)
  end
end
