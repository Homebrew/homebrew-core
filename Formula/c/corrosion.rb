class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "e9e95b1ee2bad52681f347993fb1a5af5cce458c5ce8a2636c9e476e4babf8e3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427c06338a5dfa2298f8b3d6e5e9da2aad80490fee56bce1042b70582414e65e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec0ddf15edc78bae22d82611550a2994a20bcd7194ef2058e38bc072a21a9ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56dd11a1483c0889f731f7fd4e33a0564cac7d198b198562aa354e0d12c0b469"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb6aa3505fc372e2c12959d32a2bb0aebe2637e2d12e85a778c048b8b53d4f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6019280f5f172f6abfc2b2f21a9ea4507e28401e6c4c3072cfd9e87504a7b494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee053e890e2e07b58ad476ccc87dc5d0f7bcca492ab56432cc39051fd72c52e"
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
