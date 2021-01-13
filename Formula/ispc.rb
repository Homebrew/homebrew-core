class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.15.0.tar.gz"
  sha256 "2658ff00dc045ac9fcefbf6bd26dffaf723b059a942a27df91bbb61bc503a285"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "c428ae710fdce7a000ab0e1b75b7bec3c8f465c9c0dbf1d3395abae96730bf16" => :big_sur
    sha256 "171920257482c33142b6d878f7fc87106022d8e6725761b88e9ec68f62a410a7" => :catalina
    sha256 "dd776fef759c45cd0a023bfc25216faec47f104ad100b7a4f6b630cbde256a7a" => :mojave
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.9" => :build
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
