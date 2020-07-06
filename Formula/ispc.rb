class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.13.0.tar.gz"
  sha256 "cc74c4c490ddf4e0a63f01948ec8d6eb575d85ab5932d30ca4ad01c0e8f079ce"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "ebe58acbd4a6925ed70887050ed7343e3d1da97b5973d6790560f333a08e2299" => :catalina
    sha256 "abbe12e825e7cc8e965886cd8a0e16407d7b0bfb34c419948b7e5455695747c1" => :mojave
    sha256 "16ab84a2e4d41dee3f6b4a3367dc7257c841cdcd73794379c2a56b02ad37dcb1" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.8" => :build
  depends_on "llvm"

  def install
    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{Formula["llvm"].opt_bin}'
      -DISPC_NO_DUMPS=ON
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
