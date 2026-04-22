class Miniaudio < Formula
  desc "Audio playback and capture library"
  homepage "https://miniaud.io"
  url "https://github.com/mackron/miniaudio/archive/refs/tags/0.11.25.tar.gz"
  sha256 "b900edcffe979816e2560a0580b9b1216d674b4f17fbadeca8f777a7f8ab0274"
  license any_of: [:public_domain, "MIT-0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12948d6a45969c48fd0abfe17aa631da268ba423f8271c160ed6cc31e8ccf363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e7372e92b813a137f0e372f653252daab3530e55e3d9a032ee1941049a44f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd4e9ad49caca0aa1ee4da2e8dbb7edf5b003b8a7eda1da73105f8e16a5ee59"
    sha256 cellar: :any_skip_relocation, sonoma:        "312733a8e74e4b4cded6e2429cfc4860c2eaec1a9d4bdbc6d184daa4bfcc5cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f18fa4627bcae27e0bdf8a6f904d371f3e620666ba6e8ecb1826b95d9fbf4b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0642c4bea6189bbef7f56daf9428cf3a832104ff2e5eea66a657af2b1bad8dd"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DMINIAUDIO_BUILD_EXAMPLES=OFF
      -DMINIAUDIO_BUILD_TESTS=OFF
      -DMINIAUDIO_INSTALL=ON
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

    args = %W[
      test.c
      -I#{include}
      -L#{lib}
      -lminiaudio
      -lm
    ]
    args += %w[-o test]
    system ENV.cc, *args
    system "./test"
  end
end
