class Miniaudio < Formula
  desc "Audio playback and capture library"
  homepage "https://miniaud.io"
  url "https://github.com/mackron/miniaudio/archive/refs/tags/0.11.25.tar.gz"
  sha256 "b900edcffe979816e2560a0580b9b1216d674b4f17fbadeca8f777a7f8ab0274"
  license any_of: [:public_domain, "MIT-0"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4116dff207a7fd4b5e6f2d2da3189df46f33397d09e4a06a2c074dd48f6441b6"
    sha256 cellar: :any,                 arm64_sequoia: "1ef0a99c6d5502c31c77b39d859c02adbb09b3d80eb441a85777dcf546c60858"
    sha256 cellar: :any,                 arm64_sonoma:  "9e94a62aee3436dbc9d99faada5cce88bd76249c629798098306897041355ca7"
    sha256 cellar: :any,                 sonoma:        "9a56208b00933d2bfc08b578cbbc0be50e2ac69d57103809b4e6ad48e092f084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c96b371c8f6ef73cbf576dcf4a1be1c2f4e88a3f3b5354c987d3d7ef80b837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acba976aeb2cd0c39b26921c7788f0e4cd3ae721210bcdb6116ce8775756e2b"
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
