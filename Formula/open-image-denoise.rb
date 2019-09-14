class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.0.0/oidn-1.0.0.src.tar.gz"
  sha256 "e3cb903c9def3a1485191da1a6d252055d907ed1b9a007b3bda1d3b522cd324e"

  bottle do
    cellar :any
    sha256 "b63fc5dea6c3114322d85193c709a5d5313fc53eacc359b818ffd3808f0ce2ed" => :mojave
    sha256 "2cf532b344578f9e6350816858e6fdbd5fd13bfd992fbbbaeab120e2ecbd42fd" => :high_sierra
  end

  depends_on "cmake" => :build
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
