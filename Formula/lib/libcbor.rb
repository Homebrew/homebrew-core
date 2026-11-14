class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "a8f3aa5c75a4e1e2c639a4928036a3a53fd1682037033db0964935965bd5f5da"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "09abf44954c029007bfde9232cc16157bc27fa04910520f2672df2947e175317"
    sha256 cellar: :any, arm64_tahoe:       "d3860e4628644762bda9abbf8532e5014bc9d4344b937e5b7a9b56782f216be1"
    sha256 cellar: :any, arm64_sequoia:     "82c464b084c14c94db0f4ad51a40ad5a169e8aa7389e01ec1444eeecda54b3e6"
    sha256 cellar: :any, arm64_linux:       "6ed5474ee6cc3ca4614106952a81704f298b3e0ad753d4d1707a7d32d23f0d18"
    sha256 cellar: :any, x86_64_linux:      "08abbbdc58596b08c87231c4d7d52b9aaeafdd955ec90983d639538fddc5d299"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
