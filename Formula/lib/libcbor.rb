class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "a8f3aa5c75a4e1e2c639a4928036a3a53fd1682037033db0964935965bd5f5da"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "eb1c39612f8967acd677cdbb3dac68bf3a831d3cb8ac747c6a936126aaa52d3e"
    sha256 cellar: :any,                 arm64_tahoe:       "b0a83d57d590f7d6ecf8589e0796a0ff3c08d9f3fd0f82349d5cf92d1cf4cb73"
    sha256 cellar: :any,                 arm64_sequoia:     "90ad93678b0065b521b482896d8c4f07e8274c80ee0fdcd8bc7334506e578ec6"
    sha256 cellar: :any,                 arm64_sonoma:      "a1f3c5e389d8e6804c813783c0326dace6295b025b54373b77e828f8660eaae9"
    sha256 cellar: :any,                 sonoma:            "d96512eea5afa2988783b04385f0eeba4b625c9bbf160e4bb3efa06c72d1d5fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a8784ee0cb9a8dfac1a2b7444571f8a621537932eb9bcfe1b0d65df31109007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c423643a3235f88959c0730450de47a6cd9d3a1005bcc00a6cb3f5ede22f45c4"
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
