class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "06ce668379897537c9638da7bc27247dde79194807b07ac75e18b3dfdb12542d"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5d6d02fe6ca123729e5af37bcb0f39b4eeefae3cb7e5b91d1ab70a92a3de01c1"
    sha256 cellar: :any, arm64_golden_gate: "206d5d1e289c39502a534d1b9e80447bbc9378b4a666ebcd17326c084449af47"
    sha256 cellar: :any, arm64_tahoe:       "0f0a710145bf7f8bcd4b8b8dac6aef2f260d764c08edb7c54760b7ffa8cbedd9"
    sha256 cellar: :any, arm64_sequoia:     "c962ca4083e5d2657d2bbee486b0753265af0dbff89d6b71ad2a603dfc80a321"
    sha256 cellar: :any, arm64_linux:       "e6d8a28cbac82497dcd97cd909e9ab4f3143fbfa1c4f7d4cb1926989787eb700"
    sha256 cellar: :any, x86_64_linux:      "96b79cd172096bc92fd60f071830e9319ce7fcd5217eed3128ad90c16923840f"
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
