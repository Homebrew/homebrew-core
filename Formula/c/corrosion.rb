class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "f1fbb39e627e1972a5922895548e4fecaec39a06a538a1d26225d95c219a163e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ce0fe315dffb75c813e9785f0e2130a99f989bdac1f5f2d99f96e5f1b50d062"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5398a8bd3028c9de82f6e0397c6d7c439f9c16b7f1c2246398cd14f7a4e46bed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f85c8f99f6ceef5556c5708e4e47ed2a7e78d6877945ca9cd927612a6256c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9227a4c5d668300e571051bc101a1c372ac316696b6d388c81e2f8c522643d6"
    sha256 cellar: :any_skip_relocation, ventura:        "d027a93e7e0bf942bc69322465d7ef2ec249f4a6695bc0e054b329dfb133bc27"
    sha256 cellar: :any_skip_relocation, monterey:       "f4aa596e17c6bbf0840bc853ad5741c659a8511f86ba1b40ca8d2cd1aaca5ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e4a74c5073796167d077d329226653023f964c266d5442756f6305a2f64a8f"
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
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end
