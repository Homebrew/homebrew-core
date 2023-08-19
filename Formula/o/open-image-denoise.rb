class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.0.1/oidn-2.0.1.src.tar.gz"
  sha256 "328eeb9809d18e835dca7203224af3748578794784c026940c02eea09c695b90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bdaf6403a929f235b0ff6da19baba1c951ac94e8cbf9ba09a0394a7ef322ee24"
    sha256 cellar: :any,                 arm64_monterey: "ea08619a2c5659543660997d7bcf3f39e94d34b4ad6b4dfefd0a8a94922a97af"
    sha256 cellar: :any,                 arm64_big_sur:  "35736aee28ab714cf7709dc2c537db39d05ebd77e223718224f222466ef057b7"
    sha256 cellar: :any,                 ventura:        "e1d90b853cc0b39eb5e7b4bda9a2a6dcfd10a07691583bfd371e9968fcc63b73"
    sha256 cellar: :any,                 monterey:       "7ac3e7ef40abca3755ff98de4de0b8da25ce17526da61f4ed21682e1a601d992"
    sha256 cellar: :any,                 big_sur:        "24c6e0b8efbdd9b888c2190ba1d1380c40002957993d10bd8bf2362552f0aa12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fae9536588c4cc4d1528bf42df82faaf756d3230690d6b51444a23b01083551"
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
