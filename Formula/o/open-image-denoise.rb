class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/RenderKit/oidn/releases/download/v2.4.1/oidn-2.4.1.src.tar.gz"
  sha256 "9c7c77ae0d57e004479cddb7aaafd405c2cc745153bed4805413c21be610e17b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d95bf70457651d34cf5332b662c167b9dbc8e4f27678b7252e4aa7262ce62098"
    sha256 cellar: :any,                 arm64_sequoia: "cbb4ea3a39c5e5b64a4a335e8c1971f0da2cffd9136955b0011d96e12b17745d"
    sha256 cellar: :any,                 arm64_sonoma:  "287e948aa84160719b9d6e92ce4c4466ec6423629e2b3d5a7bd7572c62812bdc"
    sha256 cellar: :any,                 sonoma:        "fa836c9d2fffa3e005bc4d57ed16ac62b2c6f3e9244a974beba6f5f053876f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bd0407c5f6e91debe6c129737804d4de434029c0244a9a1777708b9be6a9ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc9345944f34aac48dfe6e2b38c0f79d0a586ecf424f291f1fe829073878a43"
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
