class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "6b9090647d372adec2b09ac7a553458b6e39004238967f9a25e9dd8c1d77584d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2269f4cc55813ff736d10dcd49ee300c26313cead6735a1dd9347b1e218937a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "948d5a318c8f6f24d4e474418827e3f0a72bd449af40222d0e3fb0c9b24502b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe9bb6c2f4711f30f5531580f6e270ee3b236f453d4472006c83b914e9bc0207"
    sha256 cellar: :any_skip_relocation, sonoma:         "91ec019b2634cf6852cff1e489e625b99eaba07d9e8077b24046a2350ec4f632"
    sha256 cellar: :any_skip_relocation, ventura:        "1903ef8ffac92626b59f6faa5694a52afaabf99f87b7658dc195be23259933b7"
    sha256 cellar: :any_skip_relocation, monterey:       "8529160c6876fda0f6ba6e30d3cd6e5066562a9a838d62925e3bf776f92be1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcdb0daf276814700a3c3e692184c0259e624f77a234992858fab5ffe4a78f8b"
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
