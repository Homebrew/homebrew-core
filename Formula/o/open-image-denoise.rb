class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.2.0/oidn-2.2.0.src.tar.gz"
  sha256 "5864386628d35d2b555380969ac957dc52c714d01866f557d9d1400ee01e61f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b17c84c51d7566613f8c2c3c76150906752cfb21dd1aa33db4a32efa24758763"
    sha256 cellar: :any,                 arm64_ventura:  "fd2f4876584d5759fc144fcc943c255efb9678ee847279f69c1efe083bad9445"
    sha256 cellar: :any,                 arm64_monterey: "ccca23e5f6ad92073fc4b0419f9355d7942d39f4c72f619fb22db9db8a76e857"
    sha256 cellar: :any,                 sonoma:         "57f24b43e2a30aa14b4e5fbd9a33257fa7ca51f965813e3d7cc3a6049ec0b01a"
    sha256 cellar: :any,                 ventura:        "df5dd4b245d1d0d4da224d58f124df8bb88472877dcc3dab37a856180edfbdf6"
    sha256 cellar: :any,                 monterey:       "93f835ba27b1e3690e59cede45d95737fcf9a33bde653c055494b265aaa18779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889ba88f0ab3e3026ded12d3a218822506f08350b087e7c0e4a643964f86b21b"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "python@3.12" => :build
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
