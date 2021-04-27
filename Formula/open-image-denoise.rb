class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.3.0/oidn-1.3.0.src.tar.gz"
  sha256 "88367b2bbea82d1df45d65141c36b6d86491bc6b397dc70beb3a05dda566f31c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, big_sur:  "7398e8653fa5a904f0110788c24e1135542ad2310c496997015feb60af53c23e"
    sha256 cellar: :any, catalina: "10cf7627f04aee03b80b001d80ded196c3d419c2232dca8950f6a7cfd0c031c2"
    sha256 cellar: :any, mojave:   "93d16bc36a6a125f4a3ca7979c9052d890502c9c19f6820acf0e855ea073e22e"
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
