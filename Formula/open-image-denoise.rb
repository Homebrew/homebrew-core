class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.1/oidn-1.4.1.src.tar.gz"
  sha256 "9088966685a78adf24b8de075d66e4c0019bd7b2b9d29c6e45aaf35d294e3f6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8ee8585a4cc0b950637e0f727e691dd6af9480f4cafa3cbccbd72f13e7960c9e"
    sha256 cellar: :any, big_sur:       "650eea58ab394c7cf17d780d862d426cfa755edfca2677deb28a24614dbc04db"
    sha256 cellar: :any, catalina:      "01dbd67c62eceb6c2e1c28f345a434358669d18becf6436a1ad237770acf0ebf"
    sha256 cellar: :any, mojave:        "0bfd3f3fbaa6766384cbf45b97804c6cfb64c4ff4a4d447a9bd564152710ee15"
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
