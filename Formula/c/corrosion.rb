class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "1eb125f3827fddbac39c3089c18cd8d8934c950e388f83a42062e3240b4db22a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eb09c8fb05eb7bd06367f09321fbcc6a890fcbad5f143c89d6bc4f14f9305cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "417ae759df80e9540cccb8e514cd804d0906664a8f5541577002a57d838e2095"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "838548852ed891842a9daf3399a089bd0ea74d131b5fa8b50e3585f8ebd2649c"
    sha256 cellar: :any_skip_relocation, ventura:        "beb00f864f7e2d2fcdccad8a7843dadb1b1ec8a1ad5d8e4113ed4bb8093d8637"
    sha256 cellar: :any_skip_relocation, monterey:       "b8da677d20e1370e06dce1c1d889e08603e667b09dca0240e6f94e9112f5e703"
    sha256 cellar: :any_skip_relocation, big_sur:        "0228aed590edb0744d33c57fb6f67b0dc14bbcd267b089ad456d1b7256537afa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac11ac4a60eac5abb51dd6b933afb8518bb2b94e42ab772205cce70016e52765"
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
