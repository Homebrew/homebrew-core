class Ladybug < Formula
  desc "Embedded graph database built for query speed and scalability"
  homepage "https://ladybugdb.com/"
  url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "7915ac88442d9e3a73cf22199a25688b41281e6e0afbccf979fb94d48b143938"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d95c978280ab952dcaafa718784885e70b883eee335215f6f810784cc104aecc"
    sha256 cellar: :any, arm64_sequoia: "ac4c15dc85fd6e7cd0a6fc2c8d3bffb74505472067826aa44231b765a210dcc0"
    sha256 cellar: :any, arm64_sonoma:  "1a14f17341147eb1e3e53feacf5715d32baca3591b45b3bf3f0b1e7d402fb033"
    sha256 cellar: :any, sonoma:        "90eaf152b8b7e0bc333fbda8183d3cf8f4997bf1d67ff2250bfdf46e0e7bb4ab"
    sha256 cellar: :any, arm64_linux:   "21e6dab74d5497d21318da194bc932ad1bf1a4ac39c8036cb46185525bbf0384"
    sha256 cellar: :any, x86_64_linux:  "e3afd384511020e39425171f6766d663b308f548c3a7a1720f6b61fa47a18ea8"
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
