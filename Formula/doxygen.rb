class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.9.6.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.6/doxygen-1.9.6.src.tar.gz"
  sha256 "297f8ba484265ed3ebd3ff3fe7734eb349a77e4f95c8be52ed9977f51dea49df"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3b2363de6662c5f02baee6ba7125aa1bfd3063e11e4b7d0ffe95249dbe0e8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e27b254a3dff2f8d32bb335115b83d9b2a2c7149b05d9f8aa12548196d11fcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "718307b0bbf838d49bca0ab13aeec628c2ecdbb7c45f815fd066468ded4e2c8c"
    sha256 cellar: :any_skip_relocation, ventura:        "c87450dc06cd1f3d0f03d9b8c0d10c99b2c3d6547e46456ec69b487aeb0ca08f"
    sha256 cellar: :any_skip_relocation, monterey:       "74e681c39f442204f0a8826844125c6c44f72d45d6a1722a8eeac1fb0dd9ace9"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f2283441f36a5f8b547326bee5ec9d5e9bdde12e8db4cfbc183003db501c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254c81f1fde19f4e7c8eb3fa9da389634301e1885de55ef5eb5641d6909c85f7"
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
