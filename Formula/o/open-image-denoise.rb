class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.2.2/oidn-2.2.2.src.tar.gz"
  sha256 "d26b75fa216165086f65bf48c80648290f2cfed7d3c4bfc1e86c247b46c96b7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acea4e971d4aaf453a1d06192ff983054f2af4caf400166a17bb6dce02ae5b0f"
    sha256 cellar: :any,                 arm64_ventura:  "cd95523dabb4eaacb18f8ab6a31af713c4f4e7102f4ae249223295e7f987d57d"
    sha256 cellar: :any,                 arm64_monterey: "4d546535cbf21a134c5500b062d40242e0bdfba79596b2c8522acaf7106accf0"
    sha256 cellar: :any,                 sonoma:         "3c07e15a1dba4d5bae90e759d4448ebb33b92acbce4fde8996fe2f1df43170a2"
    sha256 cellar: :any,                 ventura:        "8fabc8734e17cdc67730af0d0b6aaf2ba678df4a1c799b0475ea02e911ca90ac"
    sha256 cellar: :any,                 monterey:       "1ea17d5ad62e0bc800eb52dadea3ec3aeddc953e814edd8ebfb780ee5db11fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c117553d0e972b9454980e3a49f33500b5f982c7c6a93c9c5eb6a228c33e325"
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
