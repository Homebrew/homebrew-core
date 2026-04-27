class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4c2ef23b5e7220033e8560f295435180df926d0ebab46c46d59d4fed74dc69f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29b740559332508ee6574ef8f23a91be1e251e54b1d2580686796b0161869be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27099692f7bdfdea1af84d824f8d52d09008094541995bff2e798dc93aeef20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89c76718768907a5b145395f1427a1cde9c03432aba71d23678b64226f095cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "009335258cd549a6587e9d18935b614e3227cf2e102a693e5387a632279d585c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c4387b86c07559288b0537d2d8f703a424372002f655bd51eb48e64024a0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b34d9f65b785081a480a4c291277d961baa37a7e73e73e83d691e2f97506cc4"
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
