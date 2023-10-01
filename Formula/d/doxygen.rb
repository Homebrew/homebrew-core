class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.8.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.8/doxygen-1.9.8.src.tar.gz"
  sha256 "05e3d228e8384b5f3af9c8fd6246d22804acb731a3a24ce285c8986ed7e14f62"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7699071865959f0d7a6dca86a21bd302a4a628e083f167214adfaa805b32b95c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e906f9537f6c6c2629a4eea092712750ede81ebef54c238659619c8d7cb60219"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "755c9d78f37901b10e511dd781933498a3cf0a6e3e75c609e7a47057fe42b98c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "215a7627a946c2abd09e96eed32fdd6c323d51f277d3666f7e3ff5f93c227fe3"
    sha256 cellar: :any_skip_relocation, sonoma:         "539c3f7b0da1d9c75bd24c7f74703bf9454772474502d9e875eae0542047d4f4"
    sha256 cellar: :any_skip_relocation, ventura:        "5d4bc2d2541368b2d039f6b40dddf2f9411e0944a7d8956be68c55edd0cc55e0"
    sha256 cellar: :any_skip_relocation, monterey:       "80b45ffc2a96a19cac96cf05dfedb8c151b425a83adf23788d37e53f68adb33e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5f5d8ea727cb5bea382e14bc708fc290e4d39aeb9d8d9424344db354dd8ee08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b15a3be88591ac7be718633f05d139995777be2f53a00c0740ced59ab4b6f4"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :gcc do
    version "6"
    cause "Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("build/man/*.1")
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end
