class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/RenderKit/oidn/releases/download/v2.5.1/oidn-2.5.1.src.tar.gz"
  sha256 "e71fd043a70f1cc80e301d1b90df6c1f536098c4dd94baa612742f6db3369c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c909235a75a9384114d3fcf0883d00329058f838883a7c1d6f413464aeca4b6"
    sha256 cellar: :any, arm64_sequoia: "661d9d70bc1f3b1d730ae6baf972718c86524c2da5b9a761a03a4fe018047c9c"
    sha256 cellar: :any, arm64_sonoma:  "08037a870edca1e5564d66376cb1ffcdc1d1d97b080b6c74b4514f8f15f5b936"
    sha256 cellar: :any, sonoma:        "471a7b02b669a37c0e928b7b38cc171f71778312632cdc1f060bb352d57f3ebb"
    sha256 cellar: :any, arm64_linux:   "45384cb87381b3e120bdfa8e7875197bc090671156f483aafad9e1792c9957e2"
    sha256 cellar: :any, x86_64_linux:  "c37c018d7c6b6eb0a04f03732de5b14938b02458a9f15ab0ab0b6a7c8207dfc3"
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
