class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.10.0.tar.gz"
  sha256 "0aa30e989f8d446b2680c9078d5c5db70634f40b9aa07db387aa35aa08dd0b81"
  revision 1

  bottle do
    cellar :any
    sha256 "ed627995601dca14625923e95badefbbd12def15a9733cd422255ca75ec5b929" => :mojave
    sha256 "3f677501e9519bf269b67c795c474cb3aaf1e4f96963d1e0c676424df7a0974e" => :high_sierra
    sha256 "d00210a8bf3001b4495fa2239fc54dacf8be81f246dda0c58c345635511b69d9" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm@4"

  def install
    # The standard include paths for clang supplied by the llvm@4 formula do not include
    # C headers such as unistd.h. Add the path to those headers explicitly so that
    # generation of the ispc builtins and standard library do not silently fail.
    inreplace "cmake/GenerateBuiltins.cmake", "${CLANG_EXECUTABLE}",
      "${CLANG_EXECUTABLE} -I#{MacOS.sdk_path}/usr/include"

    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{Formula["llvm@4"]}'
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.ispc").write <<~EOS
      export void simple(uniform float vin[], uniform float vout[], uniform int count) {
        foreach (index = 0 ... count) {
          float v = vin[index];
          if (v < 3.)
            v = v * v;
          else
            v = sqrt(v);
          vout[index] = v;
        }
      }
    EOS
    system bin/"ispc", "--arch=x86-64", "--target=sse2", testpath/"simple.ispc",
      "-o", "simple_ispc.o", "-h", "simple_ispc.h"

    (testpath/"simple.cpp").write <<~EOS
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
