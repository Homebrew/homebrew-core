class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "8bc9f820eaf3dad3509d7930d80c40512bc51e04989641f892ee64c46b7ab0d8"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "32c6fd2bbf810e1071862fe264dbb9f5a14a1a85f31589e1abe1cf3410019c0a"
    sha256 cellar: :any, arm64_golden_gate: "c6e350521de4f9bc89dd3ecc196344662cfb5f9ed5bc64a8b5213f6afab32aa6"
    sha256 cellar: :any, arm64_tahoe:       "21b0529461e9a56e36d3abae50a8ad55adbda9754bcaba5a480e62d179bdf003"
    sha256 cellar: :any, arm64_sequoia:     "9ac011545b8c08fb7689df78cd892e772c9a35bd5a9ef381086bb9db852710f1"
    sha256 cellar: :any, arm64_linux:       "6ea402ad91b78bf360c0ec61d8ed8e2e10e329d495b10627d194a0da81699f45"
    sha256 cellar: :any, x86_64_linux:      "bf6c5d422dd2acba58a537bb1ae82f86d2184a95a6d9a104c1408eec84221e4b"
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
