class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "3cee986d4a99fd965d70c96f6640eeff9723cc2815d367b22624ace53f3fd47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "730023945219b3aa95d76dba53b7cb13dc4ce892a2bf97ee3e4d159f229f4fd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ceeef2ae65dfe4792489c185741b437776055860c1f0bcaffdddf6617087097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a44b0f15248b34fdb6e3983e701567410cbf4084e7234efbfcbdafe592034c0b"
    sha256 cellar: :any_skip_relocation, ventura:        "88b67eba9f7bf71c986cc152570c8f757bab5402b201fff72c08f93b4773b97d"
    sha256 cellar: :any_skip_relocation, monterey:       "a7b733ac47bb0190abac44c72a56b7e294fa6fd23ee7417da68d1f62aa018f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d6c365952c65bd3c47c64e287196f85a782a6e4da98dd30c23a173cd724709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f700cec8010717fd466f862eac6cdea0629cc1f700327c3365295f0fc0eabc6"
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
