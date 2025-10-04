class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/mp/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "17cedaddb57a1df4d47bbe5fe0782f2e8d90a416130b70d291ef97513128b8dc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bf5a0d43eed837f69e6e7a1cd20d0b1e0d5cd7d17341b11bd44a9f1f2497ee7"
    sha256 cellar: :any,                 arm64_sequoia: "243e01399f49efaa494912effa97b114f146886fd2da61e383fe5ee03cbe81fc"
    sha256 cellar: :any,                 arm64_sonoma:  "a9da950919b6eb5c47123fbff37e2c9597ac01fa6ac3d8b46b9770e7c052e95a"
    sha256 cellar: :any,                 sonoma:        "12be92be01cb47cf32fa277a1f86f94cf565c01019d88011e0f60d223a7e6468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d65ee2909acdab137ba45976e25bf19b23c91704d2f460b85c3fd274a7f82543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe407627bdc0227755d9b7f90b9ebbde9657b7273a338fd506e67abd855a70f"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DAMPL_LIBRARY_DIR=#{libexec}/bin
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "mp/ampls-c-api.h"

      int main() {
          AMPLS_MP_Solver* solver = (AMPLS_MP_Solver*)malloc(sizeof(AMPLS_MP_Solver));
          free(solver);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/mp", "-L#{lib}", "-lmp", "-o", "test"
    system "./test"
  end
end
