class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.16.1.tar.gz"
  sha256 "e5dcd0d85df6ed5feb454ad9ec295083a07d7459fcaba00d5dd6266ceb476399"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "a9e533da0a8a1ad0327cbe13cf4e73712fd83d40eeff92286e9b2b404a6be58b"
    sha256 cellar: :any, arm64_big_sur:  "816feef4722edd8866c394110c503338eaba0bb373c87ddb9a898dc56b1adac7"
    sha256 cellar: :any, monterey:       "b0d22d24b1a89933c5ccc6b73968641c3ebc99839cb5e7fdbe2135cc9ce4673d"
    sha256 cellar: :any, big_sur:        "a82168d4f3a51a8078eb3603a9e3810f5a81e32e131fce032f4b505d6d0147e7"
    sha256 cellar: :any, catalina:       "168dcec41346433e47d5478793216c86b96c4e9c2a31673e21de60b5f6a95427"
    sha256 cellar: :any, mojave:         "d19b58b941d33a38e574e351d85445c5f8aee6c9ca6a164db874a2753138ae1c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.9" => :build
  depends_on "llvm@12"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    args = std_cmake_args + %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR='#{llvm.opt_bin}'
      -DISPC_NO_DUMPS=ON
      -DARM_ENABLED=#{Hardware::CPU.arm? ? "ON" : "OFF"}
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

    if Hardware::CPU.arm?
      arch = "aarch64"
      target = "neon"
    else
      arch = "x86-64"
      target = "sse2"
    end
    system bin/"ispc", "--arch=#{arch}", "--target=#{target}", testpath/"simple.ispc",
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
