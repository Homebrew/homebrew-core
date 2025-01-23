class AmplAsl < Formula
  desc "AMPL Solver Library"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/asl/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "28426e67b610874bbf8fd71fae982921aafe42310ef674c86aa6ec1181472ad0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "373a3e24b7f2657e0e73e28e5c4c030fd8c48ac80d031df842bbaca1425a8813"
    sha256 cellar: :any,                 arm64_sonoma:  "7191c28174b3e1bf2f9d8ea53919797ddca8c876c38cc90e7b848ddd05909245"
    sha256 cellar: :any,                 arm64_ventura: "5a3e9946bbe3280c0b9505a6731287c152aa629cd6e889c09c2f210d9083a614"
    sha256 cellar: :any,                 sonoma:        "00f3da5dcd89b747ee95af1b5e7adb65c3c064c4d5a40600cbce5ab203e7240d"
    sha256 cellar: :any,                 ventura:       "59211198a2cc7d3889bd4057de05f9c382a7f07f6878f9e0a6d0511dfa36d272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be998f883db133c2712c1aeeaed54f9c1f0c53891d81248be858b843feca561e"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    args << "-DUSE_LTO=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "asl/asl.h"

      int main() {
          void* asl_instance = malloc(sizeof(void));
          free(asl_instance);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/asl", "-L#{lib}", "-lasl"
    system "./test"
  end
end
