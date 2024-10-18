class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "e216e6818302d51815ac72768b1d5506190517f5f0c3b9426fd56f4bc00ebdf1"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d650f99ada33e330e23eaac7f517fabef65976ed7ee5b92cfca56e5208f7a2fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c7a0754f38ea0957194c08777b6f3e4735e99ab10de1485f4f668ef32ae6e2fc"
    sha256 cellar: :any,                 arm64_ventura: "d490a9505d3fdcff68e78b98208818716f6a5d38982f7a65fd634094c4bd2bda"
    sha256 cellar: :any,                 sonoma:        "80a689f14d9c006eb0301b64cccd6a5e7d23c84bce4637ae0c6d29fc66abec2d"
    sha256 cellar: :any,                 ventura:       "a23c36580e65097630847b2c9ee3ca2815a5eddda847f3def225fbf4738f832b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd08c7b19eef4617e2c0c7cffa482deb8ad588bb46e2b1bc1852c146b041256"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "tbb"
  end

  fails_with gcc: "5"

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
