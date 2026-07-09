class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/RenderKit/oidn/releases/download/v2.5.0/oidn-2.5.0.src.tar.gz"
  sha256 "96c3a46122759803d5f6701ffba4bef6eac0981dced5279e66f2815e3ed3c2cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c847ad77d983808044f23298075ed4506c25ac50759f847e594a525ec5a0edba"
    sha256 cellar: :any, arm64_sequoia: "20f502dd744adb1256a860877e752ebfd32576e808f9c2a89b7a18ac13651259"
    sha256 cellar: :any, arm64_sonoma:  "f174f1c578e057a6390739cd39a693cb9e1952b4087e8af15efa0b96354b6dc2"
    sha256 cellar: :any, sonoma:        "28dee6c1a6fb8693bf0ec2b11b7fbd8e03ab89d95e98fec8deec441172d0140d"
    sha256 cellar: :any, arm64_linux:   "8f8a3bb36d4d955887635daa2b5da9c527c4919ae8577ddea15e97e69eb655ac"
    sha256 cellar: :any, x86_64_linux:  "04bd9d01f484f2660597e20b6b306b5ae80e2a8ad5e7fd79f42ce7f30948c6aa"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
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
