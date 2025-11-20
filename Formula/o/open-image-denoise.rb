class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/RenderKit/oidn/releases/download/v2.3.3/oidn-2.3.3.src.tar.gz"
  sha256 "ccf221535b4007607fb53d3ff5afa74de25413bb8ef5d03d215f46c7cc2f96cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "464548e57123e72ca84a442a9cfa62ac55eb73f86f7d7ec08c0654af1f7ed9d3"
    sha256 cellar: :any,                 arm64_sequoia: "fb2f37cd4206daef638b9709675e8f7fff631f1490cb4350399692a466de75ca"
    sha256 cellar: :any,                 arm64_sonoma:  "8293f0fd356661e248c12c58b5e4c51f71073a5627da0877ec11510e9b7f1c2d"
    sha256 cellar: :any,                 arm64_ventura: "ea3c2e87a36a569173f86834bd8d8d3eb55eaa306c7616767bb0dd4e930fddf0"
    sha256 cellar: :any,                 sonoma:        "99222539372f4f10834f985f8edfba2f1437a642872ef8045bb06e4f3cb25eed"
    sha256 cellar: :any,                 ventura:       "35b3558245c2e6631e88bfb6efa5c2fc095775e54507f7c80acf4b995d495bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e8d55aeccf7b7b57fc294722c980a7f4dfbc98ea9477bb89a8938408085e6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a922b413332b0dc8202a4fe78c372e38a3598c95d91333c1d31de22616843f89"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  uses_from_macos "python" => :build

  def install
    # Fix arm64 build targeting iOS
    inreplace "cmake/oidn_ispc.cmake", 'set(ISPC_TARGET_OS "--target-os=ios")', ""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <OpenImageDenoise/oidn.h>
      int main() {
        OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
        oidnCommitDevice(device);
        return oidnGetDeviceError(device, 0);
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lOpenImageDenoise"
    system "./a.out"
  end
end
