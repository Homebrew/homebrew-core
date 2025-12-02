class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.10.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f25ca87f936785a700c936f8688f53288f56a0b3381f733903c8015e043c66ca"
    sha256 cellar: :any,                 arm64_sequoia: "f93e79a8c9bbb23141884d1fd55ebbeeb61d5a7665216b9d7db827326696e60d"
    sha256 cellar: :any,                 arm64_sonoma:  "90427fe8b299fa3dd6957524230ba594113461d675d82a24d4a8620dde6fa95b"
    sha256 cellar: :any,                 arm64_ventura: "c9bda2b56948e4699561887fa2bcc1e7aa3569ab1b5809cc8d1735783ba8a484"
    sha256 cellar: :any,                 sonoma:        "75599a64a2330bcf425ada92665a9cdeb1947cfa233537f2262cb91271ec9b99"
    sha256 cellar: :any,                 ventura:       "18ce0a09b72766aae3aa5350221de2181c7f292f0b432e90805c6926c273283b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3deaca23949aeb02d9640edd9b3799226b6515bbd9d862dedd30b68b4f01d878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "780804999964b261746f467387a11366e6c197f23d703181111101ddc0f8204f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg@7"
  depends_on "glfw"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
