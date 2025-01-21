class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/mp/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "9ac4b03dd03285cfcf998d81b53410611dd3ba0515463b70980965ec51e29f0f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07c2f88aaeea323a876870c8c4fb107193cee09fc8e591cf39c9710812be85e7"
    sha256 cellar: :any,                 arm64_sonoma:  "3daf4ac5b5d9765794ed359c5838c3e07183f7e209e962a4d30a0f2a8bf06062"
    sha256 cellar: :any,                 arm64_ventura: "3984cfa43e3ec758a3d4cda736af4f70d51a55e4c8fbc271b691a3fc6a42e33d"
    sha256 cellar: :any,                 sonoma:        "81efa3c47b7241ad4adf50e1a50653472de841337c8a72620b8b8015eda4ba02"
    sha256 cellar: :any,                 ventura:       "d102b69020fdb1d2d0c49b2e4bb70498b154a1950533640b0dcfec0ab0069f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1548c6099ab8d8e657a0ab983deb4c7b4f1c32d0658f40c90336d7571e0b19ed"
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
