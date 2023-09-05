class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.10.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "afa084b82ac989012ba1b7a0be020dc9b3fa53fbad2fde4f29701b355d773ad1"
    sha256 cellar: :any,                 arm64_monterey: "457b6bff40820346616235932bb39c2105dd6a4a39d1026c09659bd5438a4d63"
    sha256 cellar: :any,                 arm64_big_sur:  "b05b023270b9c26d122edbe2bf3d742b33620dd770af545b3a043e14c405c790"
    sha256 cellar: :any,                 ventura:        "1cda06348a524c7d2133299fc628b226172a150eaf96bdd166d5a00ca0b7abee"
    sha256 cellar: :any,                 monterey:       "ba4ceb36a0e468e37d9eec68e085a02e82a287bda20614900a75368af6f328ab"
    sha256 cellar: :any,                 big_sur:        "b330de6ce3a5d9609fbc10eeac4c9eeca6d5254328ad3d279b72ad185aff9d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f38df03d7a2bf56fdc621cbe257ccd4316ed3ec2f6dcb6c190868db7514f8b28"
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
