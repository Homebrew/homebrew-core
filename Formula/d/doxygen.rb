class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.13.2.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.13.2/doxygen-1.13.2.src.tar.gz"
  sha256 "3a25e3386c26ea5494c784e946327225debfbc5dbfa8b13549010a315aace66d"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a5f6b558cbcb85ce1dbd7d83b12efc412d7075704b9b4c43e3dfe9b9329993e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa86ff994b5dcb318bdcaa254f5a362ff75619737a042021ebb75a92d33916b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d726ffc4e7df5f51137b312f5746e5828126ca1f71b733c80d3a6ccf1baf168"
    sha256 cellar: :any_skip_relocation, sonoma:        "09867504c3d527f0964e543466644ffe2da3ad10ffd8544ef355b4324d06d2f4"
    sha256 cellar: :any_skip_relocation, ventura:       "4dadc96efe27d3d615ae06a1196c444dd260201122a1b11612147615bd2fd07d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f7e4556f199db6e58e615dcc5a39cbd290f388d2e68746764db5c240f6468f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58d06f93c341a4fa403c88b5c7144a00c155f71206d7e457c537321d3e833db"
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
