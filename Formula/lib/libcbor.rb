class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "89e0a83d16993ce50651a7501355453f5250e8729dfc8d4a251a78ea23bb26d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1316d2dd79be63a69f00cf06f50dc76fd24ad9e08552cff8afcfac0ef405e858"
    sha256 cellar: :any,                 arm64_sonoma:   "173091f8ffca1b73c4c17bbe5a7a6034da4e561b9e13d6e78ca536f56e364015"
    sha256 cellar: :any,                 arm64_ventura:  "2adc8eddfa152c381152c94e3514cbabcc1594b56db0f89ac0d63a1461254f15"
    sha256 cellar: :any,                 arm64_monterey: "a50c96cf0fd55aff2d31a5b2115f9464b65d7f405339bbbde736413a29d67a59"
    sha256 cellar: :any,                 sonoma:         "d7862b97499968a3bdf6ca866c806bbc81664b465c4703788ff4501e7d77269f"
    sha256 cellar: :any,                 ventura:        "cb26f56b5ff9f67eeefcde7767e6a83263ba3736cdfcb3ed632aa2f4acb71197"
    sha256 cellar: :any,                 monterey:       "edb0c54d2580c8ddff49ffc2cea205af83cbbddbb6baf9f9443ffdf5496b06be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f26df577970defa0194f44b476b2f91d606bce7798c15b5d98cf80038db2f67a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITH_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example.c").write <<-EOS
      #include "cbor.h"
      #include <stdio.h>

      int main() {
        printf("Hello from libcbor %s\\n", CBOR_VERSION);
        printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
        printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
      }
    EOS

    system ENV.cc, "-std=c99", "example.c", "-o", "test", "-L#{lib}", "-lcbor"
    system "./test"
  end
end
