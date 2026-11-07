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
    sha256 cellar: :any, arm64_golden_gate: "6d319b4716fddace606fa62353adcb97f16ad3ab98166d1a40428223847de629"
    sha256 cellar: :any, arm64_tahoe:       "b6519061716f3110f1022f197fd13138e4413d9418fadeea5bb29d7a191c0210"
    sha256 cellar: :any, arm64_sequoia:     "cbc0f691855547e0d23f21b7ce536e714c82b1625c83d737f7f028d163939266"
    sha256 cellar: :any, arm64_linux:       "c80b3545c4e0826f9507ba6ad228a2dfe9f8681a14cd9f2bfcb0b65a2a3f0a91"
    sha256 cellar: :any, x86_64_linux:      "ed453e3ce1aa157f48534b69cf33bd49ffaf3440d409d9164578dd3b9e10053b"
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
