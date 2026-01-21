class Ispc < Formula
  desc "Compiler for SIMD programming on the CPU"
  homepage "https://ispc.github.io"
  url "https://github.com/ispc/ispc/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "d5819f3feb66eeba31e080a880b5b47b6bdbf8462cc145cdf71f535af249d88f"
  license "BSD-3-Clause"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9442dfb39dd78c2dc7e0e03291077fa2cf2355376243ffd6783231789585ba6"
    sha256 cellar: :any,                 arm64_sequoia: "6741b207cbf0496215cf9995a60ea6ea1270db20c8e522d3a877c438720bc083"
    sha256 cellar: :any,                 arm64_sonoma:  "5ea53973b788c29ed03c298edd6a8b99a34a4f335819fd0ee4ba76bafd44d601"
    sha256 cellar: :any,                 sonoma:        "f50862e874e57c3325bc02c76a57798bc4d02ab2e6476dc0fa1ef08d38ebf0a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63b2bbf4afd720a2f4e372a3687f92c393ed383496b908f4c80934591d112071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "706ed77632178f84ece9b0f2c5cb89a9d2f49e896c8a1d3537fc4ebcdc77f199"
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
