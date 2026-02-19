class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "73b30c74fdfc56c3097015476df14d0a4bcb6705d9e286c6d51c1ed578d49e22"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bdc1d455e185c88f8520edbfc67471f5b687752765811712548ed3835e11817"
    sha256 cellar: :any,                 arm64_sequoia: "2322d9bc5f413ac944cfadd524f268a467a685e2853552a6d2781c313bb9544e"
    sha256 cellar: :any,                 arm64_sonoma:  "913706450be7b0ddf4c2540faa9d4c6ff2d477e105f4f587da5438a423246932"
    sha256 cellar: :any,                 sonoma:        "34d56a54439aeee4832e56b54d9c8dcff9bdcad67e35d6d2ad312fd8fd0b7d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b201999610c12ce48c9a70127f16fb675a84c1c78cc0f8a573d0933a1dc5447f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c75d3435f08639793b1a886a79adbf9fb02e504d568f2620471330317f7d06"
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
    # Disable 32-bit Linux x86 target to avoid needing 32-bit glibc headers which
    # are not available in our build environment. Also fix the dispatch target triple
    # so clang can find the architecture-specific glibc headers.
    if OS.linux? && Hardware::CPU.intel?
      inreplace "cmake/GenerateBuiltins.cmake" do |s|
        s.gsub! "builtin_to_cpp(32 linux x86)", "# builtin_to_cpp(32 linux x86)"
        s.gsub! "--target=x86_64-unknown-unknown", "--target=x86_64-unknown-linux-gnu"
      end
      inreplace "cmake/GenericTargets.cmake",
                "\"x86,32\"",
                "# \"x86,32\""

      # Patch the skip function to ignore 32-bit Unix/Linux targets during stdlib generation.
      # This prevents the build from running the new 'ispc' binary for 32-bit targets it doesn't support.
      inreplace "cmake/CommonStdlibBuiltins.cmake",
                "set(skip FALSE)",
                <<~EOS
                  if ("${bit}" STREQUAL "32" AND "${os}" STREQUAL "unix")
                    set(${out_skip} TRUE PARENT_SCOPE)
                    return()
                  endif()
                  set(skip FALSE)
                EOS
    end

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
