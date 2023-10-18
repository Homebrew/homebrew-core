class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "ac0941ce4a0aae76901133c0d65975a17632734534668ce2871aacb0d99a036c"
  license "BSD-3-Clause"
  revision 1

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af5ef48ee6f33c9ac86c183eca004fbf4f254187c715f5d2c3c0f42b8f5243c0"
    sha256 cellar: :any,                 arm64_ventura:  "7e43f261e5dfc5b6062bcdf8dacf85c8f13d8019bfd5b91bff91e09724d95359"
    sha256 cellar: :any,                 arm64_monterey: "f37589c9357b32bbf8274630132d4e87b8affdcb6f39490ee6fedc1b272dce6b"
    sha256 cellar: :any,                 arm64_big_sur:  "52716d7e78db928ed6cc15b79cf45ce0d57327e4650a68b31de885c3057da246"
    sha256 cellar: :any,                 sonoma:         "c20fed701b750163625b9704a870bc2752e2e73393c8298ba2563edb635a331a"
    sha256 cellar: :any,                 ventura:        "75f9cda460ab9dc1217bfee756ec3542869498fb27d3875de070b85be607e860"
    sha256 cellar: :any,                 monterey:       "3f3ceec3a5612c379c913d397ba78aa1797898845457df0e4ed0746b69b71bcd"
    sha256 cellar: :any,                 big_sur:        "24c8a8f743f466ebb7e66f35bdb93995562528dbfc132f642ed35cf08e24dfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8feece2fe5d215ca1114272961bd30c7b8549dd2d8efd6988721ddd9f78a9439"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python@3.11" => :build
  depends_on "llvm@16"

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
