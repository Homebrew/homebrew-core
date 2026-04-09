class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "5549b5a50a84f61cb18c35a964ee8c9b26c56952905f9e108ad58fe33fb9a5c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f87b1de983a4628da1c4816b421b95ae6a9bc1325630c19089c84d47e297d5f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c4c0fb4948eff902a22b44b2707021d3c765f92d39ddd9654480de1d84e3f6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1db58efa79850da4608f923eb0ca0ff84ed5c9617e3e73d9f07bb5aa6a763793"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee943343ef0ae1d768c1b40450eb885f0998130ab255195ec592c1a8a253e407"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa4c11881612858bdda650677927ed731c081b3347125312640e4a8c9af2d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7cc19c09379647d54a1486acb69fbbd15af94db87c3d33f689831f615a4130e"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tools/shell/lbug"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbug --version")

    # Test basic query functionality
    output = pipe_output("#{bin}/lbug -m csv -s", "UNWIND [1, 2, 3, 4, 5] as i return i;")
    assert_match "i", output
    assert_match "1", output
    assert_match "2", output
    assert_match "3", output
    assert_match "4", output
    assert_match "5", output
  end
end
