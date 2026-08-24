class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "39d58c2250f1d3936342b811fa88ddaaf57dda17477fc576257da0fcf0fc2dd6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8403bbb3f7f37c218119f818c59d0c39cba586f7ffa604d2c7381a95dc4da49a"
    sha256 cellar: :any, arm64_sequoia: "be79a28833c3fde89ee6d7a0bc90b58333d84f6855621bf0090ab547886468af"
    sha256 cellar: :any, arm64_sonoma:  "e2b567ec441f682e88dbd01f4b0f29ca9a14993b070bebedcf84eaffc4bdc8cb"
    sha256 cellar: :any, sonoma:        "47097c5ea1b7ddc7b241da05136c7d860aaddfe2f15be53c5a8525c8fb7ee0c6"
    sha256 cellar: :any, arm64_linux:   "bf72e6db929e140e4aa98bec21f952d1965342ef61a1f91928d85d686100ded3"
    sha256 cellar: :any, x86_64_linux:  "92e47d7bfb6de9e02936bb0f6b1d841ff657039d3bf69f7151162759aeaf0f68"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C+++20 support for `std::atomic_ref`"
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
    system "cmake", "--install", "build"

    # Remove unwanted headers and libraries for `cppjieba`
    rm_r Dir["{#{include},#{share}}/cppjieba/*"]
  end

  test do
    # Upstream versioning up to patch version, so skip for 4th number in version
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/lbug --version")

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
