class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/v1.18.0.tar.gz"
  sha256 "81f2cc23b555c815faf53429e9eee37d1f2f16873ae7074e382ede94721ee042"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a08e384a9b0c3c245ff4a6cbe1fa6ed15e0d3c945d9460a59f65bc63d7d450a2"
    sha256 cellar: :any,                 arm64_big_sur:  "0ce743ffd6bbbabecceb297a94e9c20f4107e20db8a46c7522b61589cd71863a"
    sha256 cellar: :any,                 monterey:       "9b91c5efffd6dcde54e226d916be142e1e570d2ae11dec58142623d9acb6e9e4"
    sha256 cellar: :any,                 big_sur:        "b6919de74b7032e94162f26bacbd17b2ce6bbc75a030112b7bd88d44a33eeafd"
    sha256 cellar: :any,                 catalina:       "986891678c5e2c4384af39093142ad2bb0e1a7b5e13e3e7a0bd9d18581f28473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c545a1a33a3df24543bd671f26a0e03a7551b61d8ca7ba107e6e2e03e2227c5b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.10" => :build
  depends_on "llvm" # Must be LLVM 13

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    # Force cmake to use our compiler shims instead of bypassing them.
    inreplace "CMakeLists.txt", "set(CMAKE_C_COMPILER \"clang\")", "set(CMAKE_C_COMPILER \"#{ENV.cc}\")"
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_COMPILER \"clang++\")", "set(CMAKE_CXX_COMPILER \"#{ENV.cxx}\")"

    # Disable building of i686 target on Linux, which we do not support.
    inreplace "cmake/GenerateBuiltins.cmake", "set(target_arch \"i686\")", "return()" unless OS.mac?

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
