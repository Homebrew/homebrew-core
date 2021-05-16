class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.0/oidn-1.4.0.src.tar.gz"
  sha256 "3e7b85d344b3635719879c4444f061714e6e799895110bd5d78a357dc9b017db"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8489e561617733ecee003ac96bcfd7cf22702e0ccb0f446e9157be8037a8f498"
    sha256 cellar: :any, big_sur:       "9674c34f67ae48f05ec1790a126b880e0d3d528f6692771cedbb70254f8d1ee5"
    sha256 cellar: :any, catalina:      "05431f04f40f23e22031894837fdbdafd18e01dee3d1c593a8f7179b8e1f0e17"
    sha256 cellar: :any, mojave:        "263de10fee2ef765861484b291fd5cc8f24ad625416ea81b1fec604ae5391745"
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
