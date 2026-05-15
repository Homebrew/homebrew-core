class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
    tag:      "3.5.2",
    revision: "edb58380ba8523d32e72966d0d0508ba78c28ffd"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f1579f56c5a86e383914f713e890eac7d18f78389edee0b66343a42ea8fa462"
    sha256 cellar: :any,                 arm64_sequoia: "79ba95dd1db4c757f3fbbac82965bebaaa59296e9642d852068132435bd8b0c2"
    sha256 cellar: :any,                 arm64_sonoma:  "ad1602c476e6866b3f9b482a2e499ddd98ec4e5c4c8a73aa92e49f0d086e77c7"
    sha256 cellar: :any,                 sonoma:        "db23b8590ebdbbbeed58dfd817ab2d52a3a838abf18e740ea55d330c8016f535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33b5a5f882330cd436aed165045841b8a84f6f627fc56c270f032c5035f50ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4df83c750277d08f1b53aa5aa065e2d35075c122ec34dc8568e441ab06bbad2"
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
