class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.10.0.tar.gz"
  sha256 "0aa30e989f8d446b2680c9078d5c5db70634f40b9aa07db387aa35aa08dd0b81"
  revision 1

  bottle do
    cellar :any
    sha256 "d261ff3443392575d7f5b48aafa167bde7c2963817075f6d995324e86af3b85a" => :mojave
    sha256 "f9bca3610d861511fb451c14332a60f9f19d54382b46e8f1a8edc5b92ff74c3f" => :high_sierra
    sha256 "7a5b35df98fcc48e2cd774ce76b357a8fa929cb302d3b274a7479ecfe3ba45dd" => :sierra
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
