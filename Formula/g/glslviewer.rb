class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "https://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "v3.10.1",
      revision: "2671e0f0b362bfd94ea5160f2ecb7f7363d4991d"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "57c914915214b7507c84f9721d15ec80f626f41a10afb4474172eee9a564d518"
    sha256 cellar: :any,                 arm64_sonoma:   "cc73eebe09ee3b60bc5ce16ad6a782f1b0c5cfc697679b5dfbab18bcc202861d"
    sha256 cellar: :any,                 arm64_ventura:  "bca12029a7978f076ab6f731e71cac82ee34d0c3180db3fcce08f8d3bf8447a4"
    sha256 cellar: :any,                 arm64_monterey: "a7c3cfbe98494f295e851ccb114b5ce3f84c67fd5f5d8d65fdb553963394e293"
    sha256 cellar: :any,                 sonoma:         "1470438d1d73005278d1fdfc868e0042478551e80db3ba11160a66a62cd6e960"
    sha256 cellar: :any,                 ventura:        "28439e4620a08f58ce48f437d7787f324c015751ed2564a29ef8c7adaf27d92b"
    sha256 cellar: :any,                 monterey:       "8f335fe983329dbf20e1c5cae75e03c86d21120a1bb8dadcdf4ddb9fe8e9a6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7cd6dc3ae4771e777d820041109b53c309d212c418c3d626c19f524327d8e067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3934d08a398ad07ff9d771fa81df3f8f43f14ecf9b494d04ac9c7dc82f4d1df6"
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
