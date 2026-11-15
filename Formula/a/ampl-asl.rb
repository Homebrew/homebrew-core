class AmplAsl < Formula
  desc "AMPL Solver Library"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/asl/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "cf907bcd14ed172d75e3d0fd34f11b3f8e42154d696cf0f8c73e217f5bf149c6"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "36b60c5a7858d4db9ddd2c23829e17f26c92edabc26024d8d2d869275fb2911c"
    sha256 cellar: :any, arm64_tahoe:       "60f58fc31ee59a4eca8185f57ab627b7df43606e7615dddd9c8b11e35634fac0"
    sha256 cellar: :any, arm64_sequoia:     "06d1fb1f8166958b8bf53b3b365befbe35273ae9ee2b2f1a308619decdee6e24"
    sha256 cellar: :any, arm64_linux:       "b9252673d3f768fb0a5e0db566235e3a77fcf881dba0f339d2c50083cacfaeed"
    sha256 cellar: :any, x86_64_linux:      "c13d846da79122af60e3d0cd85d53dc96aab7206ddbc7d2d896e055426e2acf4"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
