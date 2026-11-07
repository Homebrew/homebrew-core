class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "af970748d21a20d5915f76b895272f8eda5b6b86a1cfb61e5b97f01f290f5036"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a2de05c4a98adeaf3d7281589974fca198a11312a45b7a4c298cbb5f964a69dc"
    sha256 cellar: :any, arm64_tahoe:       "4d942f91adb443d9e35701ecf40ef2600edae1befa96dff57ea703147605f2f5"
    sha256 cellar: :any, arm64_sequoia:     "ed78dca05f184c88c718a6a93c15865b70c46ad3d635fe704d83bdfe07c86eb2"
    sha256 cellar: :any, arm64_linux:       "f059d05755b66c4bd67f419f0f79c45683089d299180f975b5185e3af619a884"
    sha256 cellar: :any, x86_64_linux:      "9205def892771f2fbe776514bd6aec95929df3d30f423246d2a566298e58af64"
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

  deny_network_access!

  def install
    # Upstream pins OpenSSL 3 only for their CI `-Werror` and wheel packaging, while the code supports OpenSSL 4
    inreplace "CMakeLists.txt", 'if (NOT CMAKE_MATCH_1 STREQUAL "3")', "if (CMAKE_MATCH_1 LESS 3)"

    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

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
