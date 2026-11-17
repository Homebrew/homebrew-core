class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "1b8653b9ff9b841a97f2c50fd996e89e1a0cb712c3c5b0980ef16a027eb7acf8"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a30cc6ab352fae92df1a4bc69a6541270e643b9b91f16654067b1251d6bce44"
    sha256 cellar: :any, arm64_tahoe:       "b5866b2e0c718b0ff4d611fdf713515b48c08304e02f1fe50d206cf4d439bb12"
    sha256 cellar: :any, arm64_sequoia:     "232787959ec82d8eeb233ec963daccc202fc312e7f729bfd3e368fb2f77c4b31"
    sha256 cellar: :any, arm64_linux:       "03bc5ab5ce8d0d3d532501524aea5c567007ad4ab4f252a1035097f857b26b04"
    sha256 cellar: :any, x86_64_linux:      "2e3449214d36431da315df61cf1e8a0d9715090ca323cbe6c77e4b41068ddc13"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/blocks\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
