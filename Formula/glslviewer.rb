class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.1.2",
      revision: "c6eaf01456db4baa61f876762fdb2d8bf49727e4"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6e97c198e04daf58e857bd4840806edada831fcf5e28e9b42920fd9828ffba5"
    sha256 cellar: :any,                 arm64_big_sur:  "7f1aebc63995fc137a7fefae32245755b2e9e7dc8ae8772cfa6363c5d21193ea"
    sha256 cellar: :any,                 monterey:       "6cdfff97d90b8513445775f27348556fe268d73b80139c05611c88fdc1282b0f"
    sha256 cellar: :any,                 big_sur:        "da23a48d4731aa32d630ecc4331288fadf2824dc38d3f2aab9d004c586d99998"
    sha256 cellar: :any,                 catalina:       "7ddaaec1cc7d85e3c2eec04397c6e8bdd5f4ba9667ff43b6757ce1a7bd03f783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0bf76939705a12b032e02ae3a262d29addbcde725d65b5ef94e8b076d82296"
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
