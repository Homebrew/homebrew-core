class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.0/oidn-1.2.0.src.tar.gz"
  sha256 "041f59758e79f4ea29a9b7a952f2c096426820678a5a713880b6d8a6519a75d0"

  bottle do
    cellar :any
    sha256 "b7f6f3c03baed6abdb8ce8940013c100f8a08fed919b283a6b46d038f8656eed" => :catalina
    sha256 "c59673b0dd7f810cf1d7114f9f8b17849fa61cd6311b2ba17e6ccd6442723f8d" => :mojave
    sha256 "ae4f4112755a30e5350e6546616b1ca6ee25eb9d832158a2e21d0419c0a13f1b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on :macos => :high_sierra
  depends_on "tbb"

  # ispc 1.13 compatibility
  patch do
    url "https://github.com/OpenImageDenoise/oidn/commit/e321d7c90a2c706a521a3afd8913af36b121dc9e.patch?full_index=1"
    sha256 "7b5a09fff4339893f2a595163421fe9b63e4e0ce8fded13d5507ff98b1fd46b6"
  end

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
