class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.4/oidn-1.2.4.src.tar.gz"
  sha256 "948b070c780b5de0d983e7d5d37f6d9454932cc278913d9ee5b0bd047d23864a"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "944076b0d557816718f61fe55cac165ad6586523ebfa54926ceb243514307f62" => :big_sur
    sha256 "0c117deaaf32f10964c8015eeb79973d913aee536e8cf3033c0eb2f136dbb621" => :catalina
    sha256 "5a678166eb2c322130d9e9a864cf2b35ee08219b9def4a1b309a8f10f2c67315" => :mojave
    sha256 "f83735e198b5066eaace6614176f7558189b9532daf523981bed58c5719054f0" => :high_sierra
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
