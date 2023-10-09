class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "bf3981d0e066f2c877949ec59d9ed6cb193ae4ff615b73f20c64a5de68fc06ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae747dcc51ce370411e5e1f5bf18b49e95f20505ed1f71176b32693a6790bd3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c95aa4c0b4975d36b5ce54480d155cd1c6e655db4345329fe6f2e5fa8161c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f7c0eb328e1ef9504ed9b1b434a0e0c6582c19546aa4907194320fafb8c95be"
    sha256 cellar: :any_skip_relocation, sonoma:         "4243883075105e9fcf75798726f2db1451a751477e96966799f306fd282f2e63"
    sha256 cellar: :any_skip_relocation, ventura:        "daad15a5a0a7ac97e0fb8607056be70f70e4c89af9a3623e1f4ed4ff5af09c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d6721290f6fbffc878a5adfc0b441626677427185400c23671525fd9d27fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0256aed3f53742a616fcfc1d02fb2c2f0322b2fcb499ca7bfd3e3145a1193ed"
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
