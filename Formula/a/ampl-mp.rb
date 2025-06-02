class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/mp/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "229c2e82110a8a1c1a845b14e5faa960785c07e2df673bd366f755aca431c1a9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72d3f332e77de2e5b258bf56fdaec683156df0ea50bd69183472ecd3406b2f8e"
    sha256 cellar: :any,                 arm64_sonoma:  "2a002c99e2dd2fc455f9f020441173b578c990a6c2ed1cddb5ad6ba66e06c9aa"
    sha256 cellar: :any,                 arm64_ventura: "ba31187ed3d38c63fa5ce3147a1585da4dfba58c3ffc963e96b9b62bec3a51eb"
    sha256 cellar: :any,                 sonoma:        "688d982bcba62f0093d30a4a13a687bb82d2af614be4c13a38e9c5b30b9e01bd"
    sha256 cellar: :any,                 ventura:       "d3b8e2cb8821b8c3d707b873397ebdc414113380feb8d0f3c96009234a8c9234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c41c2792707a2fcc66dda70e71dfab73c2e719360b44b54dc2fe5930b4b8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1589822e026ea8029f3b8d187c37979188a056aef87dde9c30f0414a0738e436"
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
