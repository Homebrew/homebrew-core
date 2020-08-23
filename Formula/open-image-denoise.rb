class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.2/oidn-1.2.2.src.tar.gz"
  sha256 "da30dfb8daa21663525124d7e44804251ba578f8c13d2024cdb92bfdda7d8121"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "406ce42f0c495827f99546bd757e4186c2d841805a3b9f88b3ce875fb968725f" => :catalina
    sha256 "a288d6dd4ce6f0b5b80d181f00be19b83c1eae84d51dd5b6dcf35735f7b7d2ab" => :mojave
    sha256 "437aba3f7b6da6bff5a81280dbe7ca5af45309992cbddee8df3f6b562b4fec48" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  def install
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
