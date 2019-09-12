class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.12.0.tar.gz"
  sha256 "9ebc29adcdf477659b45155d0f91e61120a12084e42113d0e9f4ce5cfdfbdcab"

  bottle do
    cellar :any
    sha256 "7e06311ad988893b2f89b95791866a1edea6d3d3f21c3b78a9671363db7275b8" => :mojave
    sha256 "0597f7a59aa3a549d97f70804c82937383946152f1849162b5e7c4a5527ec3f7" => :high_sierra
    sha256 "d4db0a4b773d610a63af77fae5c953fd6ea49c3e3080a924c37b345634d48e06" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm@4"
  depends_on "python"

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
