class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.2/oidn-1.2.2.src.tar.gz"
  sha256 "da30dfb8daa21663525124d7e44804251ba578f8c13d2024cdb92bfdda7d8121"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "5c36d9284a8e1d31ca9769c14650816126e43302acf5c8be3ee66d7f75f00ed7" => :catalina
    sha256 "defb1bb5d21e21f0fd1487b632568cb52daa581ecd8204cdc2a31861b1cc2e1d" => :mojave
    sha256 "6c04bd559262a2b15f03ca3e62291929d68184a63144035cca9877d1f0c2d931" => :high_sierra
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
