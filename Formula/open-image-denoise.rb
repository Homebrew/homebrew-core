class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.3/oidn-1.4.3.src.tar.gz"
  sha256 "3276e252297ebad67a999298d8f0c30cfb221e166b166ae5c955d88b94ad062a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d0131bc6bd64a1c13e10af8a80e0008344a0f10030bef4899191e1ec9646946b"
    sha256 cellar: :any,                 arm64_monterey: "ddb1741686eb6421fa5b2785128da5af3efc0a347e16b6d9c86015e5dee81031"
    sha256 cellar: :any,                 arm64_big_sur:  "e75b39c2ab3bdeb3511f0b7083d1dbcc7f281bf0ca4efaaea2e1a66c531a3c01"
    sha256 cellar: :any,                 ventura:        "5ba9cb7d13b7f585fd3281d4edb3786aaea7562fe02b0f7b787bc324e0d039f7"
    sha256 cellar: :any,                 monterey:       "e0f79e47ac06fab83a2ce96fcc1b6ef2a53745d8282913dc3534d1d45b5075e3"
    sha256 cellar: :any,                 big_sur:        "b59c85df5b1ab15a55c5ee191d34642cc9cba1d45786b6131198c81668c32d30"
    sha256 cellar: :any,                 catalina:       "0a7596cd0a60f3032acf4ad6e289f4d0dd492dbedf0f16f911d72b51b1c4ba3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71e1c6caa0c6811d8aa321588f26f14fb6c5ea2fb72d7ff9c1ef820fd5aab166"
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
