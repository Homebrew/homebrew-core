class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "95a7f0dd333fd1dce3e4f92691ca8be38227b27887599b21cd3c4f6d6a7abb10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5c20790e57a940c90412368e2b013905e348111d24c3c1094b216d78aa5e79e"
    sha256 cellar: :any,                 arm64_sequoia: "84fbaeb706c5bade3a0ec2aa6be556b7545e85a5460be62cb3103d023c0ad07c"
    sha256 cellar: :any,                 arm64_sonoma:  "279cb56460419e5db108f86468657903311097eaec5936d628d8e52e0f619ef9"
    sha256 cellar: :any,                 arm64_ventura: "5347e4152dffb63f01f26460af587f182e55278fc515ab91490309412e319fd1"
    sha256 cellar: :any,                 sonoma:        "46da1181ecfad81747ba251a7bb0c386d2e96138c91b4b2317224e4e2d8f33a7"
    sha256 cellar: :any,                 ventura:       "2024a6093106cb35a6b490c0ddb2d93aef72a604ee0763c55f4a7fe86373019c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3d54923878f373a76b6d36c4ecd15923fea36bb794485d7121e901110ac830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18293a2b5aa8a0212b281cd516ab49a9b50238e2a0d32d287757800aea89d0bc"
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
