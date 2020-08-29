class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.14.1.tar.gz"
  sha256 "3a7ee9ab90b9e9932b7b4effc9bb3ef45ca271d60d9ec6bc8c335242b5ec097b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "5d1565effbb951bff81fc773080c9f542007ce6fb8a24f516f3d4ca6e49ead5c" => :catalina
    sha256 "f94f8f70639be6552087cc8476c1c61c06dc31f059677effd5cb2227c13a2c8e" => :mojave
    sha256 "ce5ec7e5db689f0862d754c0b27364c2edb7a6e98e7922ad35971a23b7e7d044" => :high_sierra
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
