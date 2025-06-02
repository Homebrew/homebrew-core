class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "6bc02411e29183a896aa60c58db6819ec6cf57c08997481d0b0da9029356b529"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "213e69cddff12529c1bd8485dfb76e9b61bcc7feecdf723235e279e86cf41ee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41055a8da503deea745e481139bf3d04e87ee88a7af701c1957f399e7b9131ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1e046b09209f1c0fce88cfc906738e0a00b3e60e5cf98c104b0ad2471719fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "231d7baa0ee29f9f394036d6e97da54f345ea3421a21eb5fb7ba69bfc1327caf"
    sha256 cellar: :any_skip_relocation, ventura:       "a1e7ae46039d0ec8956ef7cfa52d5df75aa684a9a371175d19a8d756293b8c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d86f4310814d7d52641fd650781e7f3524a83e92bf8103bf5b5790005bc1da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c62e44eec11b2e17fada82c09418a214e0e231326415c6e0a0d1328433ded6b"
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
