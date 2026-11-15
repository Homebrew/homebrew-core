class Miniaudio < Formula
  desc "Audio playback and capture library"
  homepage "https://miniaud.io"
  url "https://github.com/mackron/miniaudio/archive/refs/tags/0.11.26.tar.gz"
  sha256 "838ba55a21c9142adf7b76bdc4351e5cd8b7ae128f46b25ec25f94ae9969c600"
  license any_of: [:public_domain, "MIT-0"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "35da367e53c5b09407e19cfa2c328cd043fdaf167926c6fbe3281c198d3c68c9"
    sha256 cellar: :any, arm64_tahoe:       "69502d44ca9d5ef01d1e00ae6912cd9eb99278c27ec0927a53d123abef985aa1"
    sha256 cellar: :any, arm64_sequoia:     "e498ec72443c3ceec337043699d48f4add0114803fef7ed1c79be7edd608c233"
    sha256 cellar: :any, arm64_linux:       "ee09e86c9f13023461a571beb394fd1b780948bdd2ef6f651c3fe77fbe04f13e"
    sha256 cellar: :any, x86_64_linux:      "93f9e07afff8e46ca8131cbdf092e469f19e3661fa5b3dff58b46bb99bdb5e63"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DMINIAUDIO_BUILD_EXAMPLES=OFF
      -DMINIAUDIO_BUILD_TESTS=OFF
      -DMINIAUDIO_INSTALL=ON
      -DBUILD_SHARED_LIBS=ON
      -DMINIAUDIO_NO_EXTRA_NODES=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <miniaudio/miniaudio.h>
      int main(void) {
        ma_context context;
        if (ma_context_init(NULL, 0, NULL, &context) != MA_SUCCESS) return 1;
        ma_context_uninit(&context);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lminiaudio", "-lm"
    system "./test"
  end
end
