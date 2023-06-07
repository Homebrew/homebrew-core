class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.0.0/oidn-2.0.0.src.tar.gz"
  sha256 "7860c79e3768c79f158c9ca05cea7d3d0f4be1241a0b11e254cb9372934c37ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d0eba5add7290aefaf12c7e1413fd95fdebf5d58eb9122e6854ba95dd60b60e"
    sha256 cellar: :any,                 arm64_monterey: "31f06fee0d1bdf5dc0b3e68758cd86590e717af28821ee893b26d077a8cd231f"
    sha256 cellar: :any,                 arm64_big_sur:  "67d8b9d6275175ed6688842c0a5b9fd191743df77df296bc5609546c6848d061"
    sha256 cellar: :any,                 ventura:        "0ae0862c72500054ba3e5cc32dadaed3f78361deca3fc05b3cdf191b28b4f2fc"
    sha256 cellar: :any,                 monterey:       "c10a342699068d99ccf8a41fc883668dc91646477925056d4b747a6df27aaa97"
    sha256 cellar: :any,                 big_sur:        "e30cb9e9071291f9cbb03872c1a6e60be4c8d7a7440990c60b8e38248760e2a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f646d5c303116234d8a01165bcfc3ddfcbb4e6327dc5a3026c4422a5a10d6abf"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "python@3.11" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
    # Fix arm64 build targeting iOS
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
