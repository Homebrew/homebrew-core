class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/mp/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "800c5f69a15f9e7bb543f429fcae02a917c1d9365e609a52ed80663b31a80cd9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2694e480ea5f65152d17fb741aa6cae2095beeb7920ac5769d5744e2c1c0ba19"
    sha256 cellar: :any, arm64_tahoe:       "edd7fd778c50bb9ba1c719fd00323f8560ff8e3adf0e3216a95215961117043f"
    sha256 cellar: :any, arm64_sequoia:     "f000a45a16bf1a93b297689cc72879293db23e3928bad674fa1d4dcccda879f6"
    sha256 cellar: :any, arm64_linux:       "6cb8595a71369176cefcf5e4131ec311e0984e0ab4578db23d92d89c6557bf76"
    sha256 cellar: :any, x86_64_linux:      "f527f89fca9a3e455c435ddc76ec8e6a6009c009bbd30e0e99797691424aac22"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
