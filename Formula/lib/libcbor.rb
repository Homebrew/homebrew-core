class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "5368add109db559f546d7ed10f440f39a273b073daa8da4abffc83815069fa7f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4b607654d91133a0a38fcc6106bfe3504e82101f6a3ebcba6ca81109645ffd0"
    sha256 cellar: :any,                 arm64_sonoma:  "4702c138e675003b441360be3cb2933d759f54988e592f9646cf3fac08b24780"
    sha256 cellar: :any,                 arm64_ventura: "8e069118ed51f891cab2278d3c9e43d4a0b4a64a166bf5936b71c82d426a9b00"
    sha256 cellar: :any,                 sonoma:        "21328c3ce137192785b4c98e5fdc8d4e1ec5ec3055012dc1a8c0b3ba47c76f00"
    sha256 cellar: :any,                 ventura:       "c0ae5159e74053c98a47f273cf6765351e75c6218f08ad93ef3f491f6ac46a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c927b338e13e1ed044b7832773076fb068dc602f535f87f47cb6343852262d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db399e91ac8ece593925568d7c87be22096e2a2ce0a7b1dcc8fef67aea4166d4"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITH_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"example.c").write <<~C
      #include "cbor.h"
      #include <stdio.h>

      int main() {
        printf("Hello from libcbor %s\\n", CBOR_VERSION);
        printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
        printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
      }
    C

    system ENV.cc, "-std=c99", "example.c", "-o", "test", "-L#{lib}", "-lcbor"
    system "./test"
  end
end
