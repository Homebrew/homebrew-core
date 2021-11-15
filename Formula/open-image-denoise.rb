class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.2/oidn-1.4.2.src.tar.gz"
  sha256 "e70d27ce24b41364782376c1b3b4f074f77310ccfe5f8ffec4a13a347e48a0ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7ccb9cbf6c69638ff0190c2eef9946a3f0fe1ec3d404a543fd8dabfdaad199f9"
    sha256 cellar: :any, arm64_big_sur:  "57d90b61463c7e359dfc75b7cdba573b20f46400948b6bf4e4d7a4a267049630"
    sha256 cellar: :any, monterey:       "cdaa29005cfe96944c8cf39f2a9de9604d8c82eb563c27cae06b83b20c9e8132"
    sha256 cellar: :any, big_sur:        "5b27bf1bfd0a38fc2c0c93a9803a0566602e0bc9ee62d2123c6c44d2982fb942"
    sha256 cellar: :any, catalina:       "a9eeddeaa15621dc64daf7db3978a4f6d0ce0ce4281c1fe71866127b9a2db558"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
    # Fix arm64 build targetting iOS
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
