class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.1.0/oidn-2.1.0.src.tar.gz"
  sha256 "ce144ba582ff36563d9442ee07fa2a4d249bc85aa93e5b25fc527ff4ee755ed6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a96398cc02533fbaa5eb1e023eb9b55b7583962872b39de59e91bb478cf2ad97"
    sha256 cellar: :any,                 arm64_ventura:  "cda4f6d69fdff552386b1c008e33eea7b62003acd0cc3f4cd6656079d0293c27"
    sha256 cellar: :any,                 arm64_monterey: "b915493d031742df1ee7416ad75d1bfa8d55807492d14b4e3a935698f5b59ddc"
    sha256 cellar: :any,                 sonoma:         "d709bc497269bdeb4493ecf054e0f4d307471ca4e0b33d6590bfe4bfc5a24db2"
    sha256 cellar: :any,                 ventura:        "29cd93cbbad5f0022deac23e8f6d37c23c62408a536901e8120ef86740a5716b"
    sha256 cellar: :any,                 monterey:       "06722fa3563f4c9852098d3b1ce100fd3f5a7a5eb975868b2eca3b66b42bf7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0e3d1304bcc479feb9403e677c986a45c676be0d71a3a84527a2d48e24eef1"
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
