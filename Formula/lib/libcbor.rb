class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "c94145d3c22e67cff9a3325dc036b4545a49a42231553995be4947d52cf2ef57"
  license "MIT"
  compatibility_version 3

  bottle do
    manifest_sha256 "3439a5648e71219b2fc3d2ffb42660d1972325f5f20138c7a5327e7e11d27d67"
    sha256 cellar: :any, arm64_golden_gate: "3f8eec24c56884c2cf6b5ca3749cef68d71e94277a97be05b24fd942b3d63fe3"
    sha256 cellar: :any, arm64_tahoe:       "4a39325b18be5ce01f57a27618141a70b2887cd9cd0e824e857ca0439aa95f91"
    sha256 cellar: :any, arm64_sequoia:     "2f4c156c3a23ef829ce56b6a696bd0fec01fb081f56a461ec22170ec5b17fe7e"
    sha256 cellar: :any, arm64_linux:       "8f41e4a7ca665dbe2238d3dfb66dd18914013c16ba8fe2ef0210e9923854f0f1"
    sha256 cellar: :any, x86_64_linux:      "01eee0ee578f2e9df1b056125c79ccd24477826c193438d81eeeba8442fccdf9"
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
