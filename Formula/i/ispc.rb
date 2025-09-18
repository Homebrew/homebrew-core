class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "7d715ec3cc960bcc1bfe4cac0f7561de54c8c124283d15780f610de20f7fec4c"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b2f9628e1bbc50896ad5969619868d413f5d9c5c0943d16d1fb6d9d31124d1d"
    sha256 cellar: :any,                 arm64_sequoia: "7bce067a968e68bdb1af3b611241c5c5e727fc482da79357cb5e10db4113d497"
    sha256 cellar: :any,                 arm64_sonoma:  "e78330df348801db8269d9f5509302b3a762da40c5fbdcdde6f0d559b6018901"
    sha256 cellar: :any,                 arm64_ventura: "ea833f40e798cba9e0ba5688b552c88cfd7720f4d69d3c5c7fa6e6a71ddc7d26"
    sha256 cellar: :any,                 sonoma:        "2797e769e1bc654c339947f4fa3298ed1dc5e7bf2ddf79673918e13196a1ff88"
    sha256 cellar: :any,                 ventura:       "d7719e37ac509aa058f2180f1f64b812f4384e439d48629bb2b5bb000a6df514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eccc258c797b8de571fbcbceeb31a35fd25b68b189499038b7ff3fba221fcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944feeb0c0ce0a5cc77304fe1d2fb17c2f38fd57b1f53f8b087fba2bc9b46ac4"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm@20"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
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

    (testpath/"simple.cpp").write <<~CPP
      #include "simple_ispc.h"
      int main() {
        float vin[9], vout[9];
        for (int i = 0; i < 9; ++i) vin[i] = static_cast<float>(i);
        ispc::simple(vin, vout, 9);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{testpath}", "-c", "-o", testpath/"simple.o", testpath/"simple.cpp"
    system ENV.cxx, "-o", testpath/"simple", testpath/"simple.o", testpath/"simple_ispc.o"

    system testpath/"simple"
  end
end
