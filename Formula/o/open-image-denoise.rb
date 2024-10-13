class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v2.3.0/oidn-2.3.0.src.tar.gz"
  sha256 "cce3010962ec84e0ba1acd8c9055a3d8de402fedb1b463517cfeb920a276e427"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bf78ad262815065ef8b81dc58e08c6b07a7c0451c0312fc9b0b744fcdf9b4539"
    sha256 cellar: :any,                 arm64_sonoma:   "fc3c4ba67d53d8e2fa8bb99ed1c69cc307bb89c06557d711dee97901f45364a5"
    sha256 cellar: :any,                 arm64_ventura:  "01ce7b7dd522c6393a12889fcd12219d0a55b64b1acfa8d9fa825876bdff202a"
    sha256 cellar: :any,                 arm64_monterey: "b0c477236d04837d0b49d84e9704eba22a17d539bcef29755809964b6f39dab5"
    sha256 cellar: :any,                 sonoma:         "3eeffedc9f75b74c36a2a1f714abc363bf978112870a2c26377414afd7a4af3c"
    sha256 cellar: :any,                 ventura:        "5b18013ad5adc8291c15201537c5a0eaddef36dedb0dc58d07b330640292152b"
    sha256 cellar: :any,                 monterey:       "73919cbd7bd7ad3827cb362cbe262301edc58c613be4b094fbfc9fe222082436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2a4435f06185707e8a6706f21444a11c93fdb1bf3257d7a15f36b9bbda7ee0"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "python@3.12" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on macos: :high_sierra
  depends_on "tbb"

  # fix compile error when using old libc++ (e.g. from macOS 12 SDK)
  patch do
    url "https://github.com/RenderKit/oidn/commit/e5e52d335c58365b6cbd91f9a8a6f9ee9a085bf5.patch?full_index=1"
    sha256 "e5e42bb52b9790bbce3c8f82413986d5a23d389e1488965b738810b0d9fb0d2a"
  end

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
