class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "939fff7fb34e8169b54e2c48b56d38aed8e616a83265ceaaeffdc3bbd26d3865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23a0ff38f73162ee63306712e1479af420382d42513e0944b7908a7a930c0310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f1786c54a26e6c3038b072f118da9d47ae70bc0d1134b7180ac93f2c0406080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c77d9aa92287778fa6396d5f95e54283c765aa163e0304a3a91d54f3450d6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "fa651d1e6897f927c304248d35e33281efc7ab07d4cdff0dc2fabd50d5001f93"
    sha256 cellar: :any_skip_relocation, monterey:       "41eec66df2743b7281751cd72b51cf70344161cb9b185a5a739a0eb9a0e351df"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a89e8e66798514cc10c9f9cb309071035d2f18bd20b88d669dc3766e8eb8c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "face5d3eaf826ca446777895a41b04fe3504c6acc7da73d193ec0c25944d0b89"
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
