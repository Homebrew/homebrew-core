class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.4.3/oidn-1.4.3.src.tar.gz"
  sha256 "3276e252297ebad67a999298d8f0c30cfb221e166b166ae5c955d88b94ad062a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "abcfb384ec75c0be7933f21fb5b20a5f82cd5d8f45b5f64754c5b46071d71a56"
    sha256 cellar: :any,                 arm64_big_sur:  "763b04f83cdb7ebcc7cf21c57f52b67bd5e231cd33a6d7388647bd33df1c691f"
    sha256 cellar: :any,                 monterey:       "c19c4706250613ffb8832e3256f238c2c1745136bd629b13fc69052f3235783b"
    sha256 cellar: :any,                 big_sur:        "ef4e28b6d261098552eb6b295e4d1cd9a7ea55536fca0aa6d80a67ac7d3adc1b"
    sha256 cellar: :any,                 catalina:       "1fb2669f02c65527f8be5e6ce33dea156e13a2bd4127286e818da13de9708b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472e35a8971652911ae333378ebe84333a8867ebd473cb17bd2e48552b7f6462"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
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
