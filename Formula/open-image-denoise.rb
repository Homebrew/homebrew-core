class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.1/oidn-1.2.1.src.tar.gz"
  sha256 "bc75d28f472628c80768435e800a28fdb18a5d058c16dac98c00f9aae8c536e6"

  bottle do
    cellar :any
    sha256 "dd30425462d2fc4c19e8ab4c3fd0b3b2b6d27fe47dab7c5d50b342d58e721abe" => :catalina
    sha256 "e8c5f77201fe5321915bbed725d88e3cab4cd44ed13d3a80a2243b35f0e83b73" => :mojave
    sha256 "21c0dafc5a87978537a55dda39e62c056e498db093cc5ff0e2a7e2a5b486bcc8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on :macos => :high_sierra
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
