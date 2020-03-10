class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.1.0/oidn-1.1.0.src.tar.gz"
  sha256 "4dd484abea8a0b3d12d346343fcb1ab7abef8f94318d8c537f69a20c2a75c4eb"

  bottle do
    cellar :any
    sha256 "2726904812a2b5a91423e92758333d438593fa56a4960e046efb242099c7cf57" => :catalina
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
