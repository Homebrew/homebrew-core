class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.3.2/oidn-2.3.2.src.tar.gz"
  sha256 "0ca50e621294e8be238bee2d814fb0391e252e3f3c93fdd4bc253a60e0d00c68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c9517af12f5495121195eefe3027058e026a0a6ad5cdd40e42af9096ec5c2373"
    sha256 cellar: :any, arm64_sonoma:  "15bded18c166c24ad476153fbc5fde6ce2239fe8aa9700858112c175572c6bde"
    sha256 cellar: :any, arm64_ventura: "59ecace8d6f274892a7743359765bb06680c481f644043659fa1a61a21652437"
    sha256 cellar: :any, sonoma:        "1d59f9001a32f8b6608aa3b5692a132238167a3d9001417cc6d983a274340864"
    sha256 cellar: :any, ventura:       "ed02dc61b6fcaa97a0fa6d41891e93a075173b6ddc55af397b6d8097d80e3c4e"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
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
