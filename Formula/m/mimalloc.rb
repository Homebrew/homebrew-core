class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "ca02384e007f46950598500dfaebde5ff9948c1d231f5a81b058799afa64bbbb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "531c6f4aeeefd3dfaa87a75018a12a976ea0789f288016e8ac6e11ea6e09e6a4"
    sha256 cellar: :any,                 arm64_sequoia: "09fb7627b28dc7cb5350d341e7ea1ba8ad16f2ec98df65c84b618c2406c41d36"
    sha256 cellar: :any,                 arm64_sonoma:  "e9ad687531f78115303068697a66b20a00e95d959aac4c0c88fbe5c9516dd40b"
    sha256 cellar: :any,                 sonoma:        "24238383ee03d1c6977e8709f76a4a6998126f866d647b9635f6a5f47ed62442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7baa228f26392cde057cf086997e72a43006dc3a326fb5cda9823e54bf6d0ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0f517f393d973c81a8887c860018c8d8eaadce80f3784027e9eae8a690519d"
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
