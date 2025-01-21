class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "843334a9f0f5efbc225dccfa88031fe0f2ec6fd787ca1e7d55ed27b2c25d9c97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953a4fe57adefdd50058d23c8342bace9029f987dec620b09314fe55cd9a0f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62bcf0fc2e252fbe3ecfba0fc9a32c9d5ab5e9cb9cc8dfbac44ba8492bca831c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a8b7c8d6ab549cf312c74d9e8fe3433dbd830bace4630a64831600dc295c16e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd0014c092f56b48094b870e83bf0179cadb5b9a1ca21b2e7d2ae7cad8b43df"
    sha256 cellar: :any_skip_relocation, ventura:       "65d4780e454a17d7e3d855ad2c3cb555ecb18a542a7bbe2e91a59190258c79f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3056f8cce628c70aa0193c328fe8f7c52d3bd4c9519fd3c383cb494338c4e981"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"

    assert_match "Hello, Cpp! I'm Rust!", shell_output("./build/cpp-exe")
  end
end
