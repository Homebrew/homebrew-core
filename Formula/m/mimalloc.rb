class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "42c16914168ac6741eeb407e83b93a12b2b7ee25a7e14e6b4807fab8b577a540"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "196e65dcd754016132df4e7d1c5b5d71c1a7a59159a3cf9c0169e692425f7501"
    sha256 cellar: :any,                 arm64_sequoia: "7012014d0b5f9c58d8e5a8c27f5b68e23ecfa5d9e1d01ee7d1932f6f38bed9d3"
    sha256 cellar: :any,                 arm64_sonoma:  "ab81afca409d75fb4c0d570c2ee7292629148c8ab2cc18694ac301d1a58e6a2f"
    sha256 cellar: :any,                 sonoma:        "4e9317a31fbfabda20c1ac3fb35879bbf4f842fc22ae29c8494ca926809b616d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390948cd96b8cb201150ac8da27b0a345e416ec9c69a033076423a41f0db41f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "153c652e588275f065f49a9fc6e1a07310557c61e0caa56911f03e1a8c231313"
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
