class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.28.2.tar.gz"
  sha256 "0b7d1d73afa93c015814b99c97b88fa45bce822d7904e8fc4a95666ba8e3fb92"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "164ff92791b6ab740c202f03bc6129c20c4d1d13bf7cf335dbc8d67e91f800b3"
    sha256 cellar: :any,                 arm64_sequoia: "6118ddb2e5341b9c283de7876e97d0851cd49e5319a944dc2d36eadee99bf70b"
    sha256 cellar: :any,                 arm64_sonoma:  "f88ac836dd198d3abeb223aff56a881d8102ced36d910c3c7a368d80d9cee5c3"
    sha256 cellar: :any,                 sonoma:        "bc4becc60a621b4eb89b18232589807af5169b72abdbc25124c17dca9fa54a26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86634a63df81deed335f9e9c2ca55ba63e5367fa6d644059a149b36248f37434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17780220ddd874142c336338dd48df9fa6398f601233bc1c960dbdc3a86ced64"
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
