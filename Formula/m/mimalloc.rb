class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "3b4a15153a59905995f7070296ed604bb5ccc00cabb8b93446931aff77224d47"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e57154353a4985af23799456a88de494cafa6b2a9191273266d55aa1c3aeae43"
    sha256 cellar: :any, arm64_tahoe:       "ca0ddd2c2c99b0e389a2cbe6a410b9257adb299ec1f1235441a552b44ea2ce1f"
    sha256 cellar: :any, arm64_sequoia:     "1ceb924c9f955e284e21094bf8c1af015710a86adf26e1328f72aef99f8ea55f"
    sha256 cellar: :any, arm64_linux:       "9a09e0dc0ac3d08179f43d29a41d7be962bdc3e95d9b06e1a8b3a191e59e7126"
    sha256 cellar: :any, x86_64_linux:      "1c9bf9a8922b91702359309e9ffa996e597c1fe6ee04f164e2a67e7dfc83d034"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
