class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.2.2/oidn-2.2.2.src.tar.gz"
  sha256 "d26b75fa216165086f65bf48c80648290f2cfed7d3c4bfc1e86c247b46c96b7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3ceb856062acd392f967f120d0c25d9d15719f776e2282e0e1aec1539057ae9"
    sha256 cellar: :any,                 arm64_ventura:  "2299297924c0e6720230e1bff46cadb53bb4038b4dbde612f9c5c90d747ab1fa"
    sha256 cellar: :any,                 arm64_monterey: "e5f9971e9c23fff1193d51b8779a2d9b35c6a9b815bafecd37e56285476dd191"
    sha256 cellar: :any,                 sonoma:         "c43adbe42cd83f2d17d6a0868d305510536ea7b2744c037896c6145bd93715b8"
    sha256 cellar: :any,                 ventura:        "8990778f53477c96dc9509f20969dd12177cb4077a035417cf30d627dee2d155"
    sha256 cellar: :any,                 monterey:       "9798c6cd815118e3f515724c0b1e6d2b4ba4c00c97db3cb059cbb5af93456767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b58854d571834640d03b5f0ee06e3d1abe551eb2841128571c0e61cdd95ffcdf"
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
