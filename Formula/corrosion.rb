class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "578747db4225acfccb2c251dd251212a0adcdd609fe59be5479cd63080e011e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06569a564ba448ec329b4ed6c990e59297e7d7789e9029682be51d2b702b7c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d84249ec3b1eaaa21068ab743ba3a8e39b472666c1d02f30c67f143ac055933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4ca86465d1ce22c9d715d40fbed87a15c865bc68910e3d184249e3026df84fe"
    sha256 cellar: :any_skip_relocation, ventura:        "70cc95ab5e79a76e27f6ef1c11c1b29e2e898285295efffc907a91c64a0a1bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "4166f777e8fe19a5a23b24a715c6654d0d5c3652e92150cbba853ddcb12735db"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f402b202aaedca00e5c5217e195410db10df36a20d669ebf6d3f5aa46538aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd7ae6171c3739dc716d198934f26072d1f42f38e6502c114fa092c9eb7140ab"
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
