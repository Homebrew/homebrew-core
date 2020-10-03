class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.4/oidn-1.2.4.src.tar.gz"
  sha256 "948b070c780b5de0d983e7d5d37f6d9454932cc278913d9ee5b0bd047d23864a"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "36e3eaab701c477b99a8dd45ee9280de718aeb561429d9583cb2a387b9eace13" => :catalina
    sha256 "3fae1d44be63e61401450dc6c3f0afe8b56bbf138e8c764e915911677749ee05" => :mojave
    sha256 "768e611cdf47486bcd8167cd2532b944f10f2fe0d7895d7f0403989529932e06" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
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
