class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/mp/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "c75274fe2ef8b61f67826267e3c2cb339021c62d724659ab89a5b63c3959067d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30101ed35bf353b25c5224e894becb501685e269097aa0877a9a4c286a6bd921"
    sha256 cellar: :any,                 arm64_sequoia: "46d3b4c4c29281c043ee2206f12e45d5ee5dba76ca6408f30c94a6263ff02bd5"
    sha256 cellar: :any,                 arm64_sonoma:  "000e6da1549a75a543cff02b98e31f777151bd9edca3d6908e06c7c11e2b3fbe"
    sha256 cellar: :any,                 sonoma:        "fe02fb7f4695515aabb254a421a0f6033e859593769792ba37900eb2c43810d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb19ab7bf83a1e77ff0c031e42ae25e2ec352d323e458eba67d3d96dd77eb06a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd14cb46a1706778ca2fe9d203ff74a90fb9c7d88dd8dd4eb3b3bb9dd53ced4a"
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
