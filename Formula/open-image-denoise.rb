class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.1/oidn-1.4.1.src.tar.gz"
  sha256 "9088966685a78adf24b8de075d66e4c0019bd7b2b9d29c6e45aaf35d294e3f6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "adc80a5739fc95b3b4e5d8c6d0637152e44f9bd78be3456d7c0c5b5709fedcc9"
    sha256 cellar: :any, big_sur:       "812efb4238f2b348cec46a3ba1ddaeef0cbb827d20e3d72064e2e280c2797d5f"
    sha256 cellar: :any, catalina:      "3d0c243ebf63e711485b7b22220d20428cbb7bc1da2308fde0ca0d3f0423f6aa"
    sha256 cellar: :any, mojave:        "2d472aa7cc5a702aa05d312ea0d17b5c5fe87ce784b4cbce9628abd940d8ffe5"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
    # Fix arm64 build targetting iOS
    inreplace "cmake/oidn_ispc.cmake", 'set(ISPC_TARGET_OS "--target-os=ios")', ""

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <OpenImageDenoise/oidn.h>
      int main() {
        OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
        oidnCommitDevice(device);
        return oidnGetDeviceError(device, 0);
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lOpenImageDenoise"
    system "./a.out"
  end
end
