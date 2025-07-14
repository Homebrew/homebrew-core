class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "c41ae29e4f6b1d37154610e68e9b7a0eb225cd7c080242ab56fa0119e49dbd7a"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be75e6c28f90c2d54f288e0268803e52421c130764bf72df3dde613b7e7c81fc"
    sha256 cellar: :any,                 arm64_sonoma:  "9b71c4bd3699d3f5d095ba599530ef86581be0c8abf543dca123a3201fdf8849"
    sha256 cellar: :any,                 arm64_ventura: "12f513bde46acf3e834f611ba80a32693ab39c443cb6826a7a844dc4133f0d95"
    sha256 cellar: :any,                 sonoma:        "ff78c5988bbaa1d87c3e117dfdcef16c68aea0f430ea113a44b6491345d0eb75"
    sha256 cellar: :any,                 ventura:       "3bd271b4ea0f43414226cf6fb3a2951b944da88fcc7416c0065e74424271f5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f11552068773867fad6194a4b352088c21da18f4c607a79b40878640c1780c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff95b06a16ccb8e759c1957ee2f6abf630b468e63acccf204b78eaae7ccf7ae8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "llvm"

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
