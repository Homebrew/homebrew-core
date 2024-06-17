class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "a45ec5402d8a3b23d752125a083fa031becf093b8304ccec55b1c2f37b5479c3"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54fa5a0a549861e1de159999de691426f573c126adc7a0d69bf9fcd294180cce"
    sha256 cellar: :any,                 arm64_ventura:  "7c55ec8a529fb34cf8f085433586363b222a0ba6afb225fa94c266b21183d91e"
    sha256 cellar: :any,                 arm64_monterey: "26c15e7e84c676fdf79f818f38c5a95296a6ecc4b958bfae06bc637e9846e83d"
    sha256 cellar: :any,                 sonoma:         "237a797a7178f652c1137947c31e16216e8befaec98c40d19943fe6cee2b2dc7"
    sha256 cellar: :any,                 ventura:        "9bc5d7902ca0a355a502afa39a63812b654f3643e8f15189cf9825f378070e39"
    sha256 cellar: :any,                 monterey:       "7ca251d052ec6bbb9b0eee31a8d65008dfe8cd2caa6ae0fa5a73e88017d4d1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0292ec3a7d8efc0efdcf854ac28f44b0cfbe82f22c58d93d8afc5876f9670ff"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.12" => :build
  depends_on "llvm@17"

  on_linux do
    depends_on "tbb"
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

    args = %W[
      -DISPC_INCLUDE_EXAMPLES=OFF
      -DISPC_INCLUDE_TESTS=OFF
      -DISPC_INCLUDE_UTILS=OFF
      -DLLVM_TOOLS_BINARY_DIR=#{llvm.opt_bin}
    ]
    # We can target ARM for free on macOS, so let's use the upstream default there.
    args << "-DARM_ENABLED=OFF" if OS.linux? && Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
