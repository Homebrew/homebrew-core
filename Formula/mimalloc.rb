class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "4a29edae32a914a706715e2ac8e7e4109e25353212edeed0888f4e3e15db5850"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3628509c807ce90ddbd4f31002a9457e8f517bc8a752a1f40a2831e93f9eea5a"
    sha256 cellar: :any,                 arm64_monterey: "b59c78d2b01ae6199bfe1d1dad6f5bbdc08a7322c4b66314ecdae1abffb06140"
    sha256 cellar: :any,                 arm64_big_sur:  "269def3ed2318340f1d60695d4928261cb37c809d0535707af1cfd3effa48022"
    sha256 cellar: :any,                 ventura:        "0ced178e11021557b80b1757f50f0eb7d2df234cc13b80b280d2ab566bf76a57"
    sha256 cellar: :any,                 monterey:       "00ca941816ee794e5cb573ec832e4391d716d1b6e708d48a89ec940a4a5386f9"
    sha256 cellar: :any,                 big_sur:        "a2e3579c97a035bfdf4e611c8a6cef68fa5e56dcb770047adb2c73f1839f1fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95113a19ace175085e8bc78020b42243c375cb36e76624d947c6e7a336db396e"
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
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
