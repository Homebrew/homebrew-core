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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "066c6cbceb92fa5498064ad6cded8c771ee479c7ca4c745f69499435823ca1f2"
    sha256 cellar: :any,                 arm64_sequoia: "abb0dc3dbeea2724625b3c46a31e009357ade922b026b9bc652ee03b9a842e77"
    sha256 cellar: :any,                 arm64_sonoma:  "0502f0c6d3be0a8ae5cfb9ebee46c1abe780294eaf3066c242011203c4b60287"
    sha256 cellar: :any,                 sonoma:        "f25e5c473bc951a15de6fc0b9f00a881cbfffb2d059c5fd3a194064ca50bfcad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cf3dae91df21f4e97b9232bb017ef63b3f6e3829f2a4f2ad06101b6e63f07f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4bc30e194268208bc23db431ed09e368124a4ae72e77bd7dca7592306a97783"
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
