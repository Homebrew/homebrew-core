class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.14.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.14.0/doxygen-1.14.0.src.tar.gz"
  sha256 "d4536d11ab13037327d8d026b75f5a86b7ccb2093e2f546235faf61fd86e6b5d"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40bfbccc24e4a47fa76132b5b9e93dbf9979b46b04cfd3316ebacd4d71ec818c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebdcea704e78247e895540b2cc38730836c83a00f5d8a6f3162978e099b6ebb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a46b8f6665c2fcc12dcff6285789407a37b5bb34d53f27bd9b90b004f7ee7caf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d8d2780826e581690992af42dad0d3f9ec7bfab8d737a53774a260640738e30"
    sha256 cellar: :any_skip_relocation, ventura:       "51211f6d675d60fbfed317a5a381041fc7bcd932e5eddc455a78190b1d5916e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1677601eadf3a7dc700d269ed2e0b1707c5608420ce5d8a7cbe087b8da941e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766c77721c7de00e57aaa62cdf457d9f38d1d53cd3a23f152920e885e37b4d84"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :clang do
    build 1000
    cause <<~EOS
      doxygen-1.11.0/src/datetime.cpp:100:19: error: no viable constructor or deduction guide for deduction of template arguments of 'array'
      static std::array g_specFormats
                        ^
    EOS
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
