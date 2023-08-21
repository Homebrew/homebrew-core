class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "16cd5c4b29a859790c446c4c7aecea21140fd06657c016672746020e2019841e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fbbb609dfaecb0b291d1fece409726f0289cdbdc18672d69e00b24707750b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0ba845b1336f5b2890d20bb1583cf3a3a37b73fbe1f52297f5099fbf34420e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5da079eb4068557c2bd6888dd9c21293e352daf3ba4d0c391f83465529a6c9"
    sha256 cellar: :any_skip_relocation, ventura:        "f86b75759b2b067e3db07c54c6218b880d738bb67599531343dd89c5516da9bd"
    sha256 cellar: :any_skip_relocation, monterey:       "210d591c12fb656227a795728d4fe17d4ff92b184bb65015a592b0ce7c1d97ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1294bd0649fffb803ef1f2baf8d69dfd17d1513e0194ce1ccd337336ac07812c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6d1e65c72bb76988d69a0d25afcb29922238a0406f8c897481d04861ab4534"
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
