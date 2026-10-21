class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.6.tar.gz"
  sha256 "a691bbf63a51da753a24b59027dd603c91bc2e90fcdd1abc042e241453164f5a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0020fe66e37d0233a9471d5ac085299dd6bd4bc97de4a3b80f1126e77eb3b8ce"
    sha256 cellar: :any, arm64_tahoe:       "4c28f7a1c1668e0eadee5019308fc8e46388ead31e9039cbe8afe96676655a82"
    sha256 cellar: :any, arm64_sequoia:     "8c6dbffd9547418c3651c3b37649e6fbe31f06bcd1b9e20e195de41dc608285a"
    sha256 cellar: :any, arm64_linux:       "742b99d2696114f88817909bb03661cc280ad45a81224b20d8653067757b9883"
    sha256 cellar: :any, x86_64_linux:      "623987a5773f09c96bd6d89191f10b06fab0c4f58f619e3ab67513a83ece0f2b"
  end

  depends_on "bison" => :build # macOS ships 2.3; esbmc requires >= 2.6.1
  depends_on "cmake" => :build
  depends_on "immer" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "bitwuzla"
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@22"
  depends_on "python@3.15"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  # Avoid std::atomic<double> arithmetic, which needs libc++ 18 or newer.
  patch :DATA

  def python = deps.map(&:name).find { |d| d.match?(/^python(@\d+(\.\d+)*)?$/) }

  def llvm = deps.map(&:name).find { |d| d.match?(/^llvm(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      -DLLVM_DIR=#{formula_opt_lib(llvm)}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib(llvm)}/cmake/clang
      -DPython3_EXECUTABLE=#{python3}
      -DBitwuzla_DIR=#{formula_opt_prefix("bitwuzla")}
      -DENABLE_PYTHON_FRONTEND=ON
      -DENABLE_FUZZER=OFF
      -DENABLE_Z3=ON
      -DZ3_DIR=#{formula_opt_lib("z3")}/cmake/z3
      -DENABLE_BOOLECTOR=OFF
      -DENABLE_BITWUZLA=ON
      -DENABLE_GOTO_CONTRACTOR=OFF
      -DBUILD_STATIC=OFF
    ]
    args << "-DC2GOTO_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    args << "-DENABLE_BUNDLE_LIBC_32BIT=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.env_script_all_files libexec/"bin", PATH: "#{formula_opt_libexec(python)}/bin:$PATH"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      int main() {
        int x = 5;
        assert(x == 5);
        return 0;
      }
    C
    output = shell_output("#{bin}/esbmc #{testpath}/test.c --no-bounds-check --no-pointer-check 2>&1")
    assert_match "VERIFICATION SUCCESSFUL", output

    (testpath/"test.py").write <<~PYTHON
      value = 5
      assert value != 5
    PYTHON
    output = shell_output("#{bin}/esbmc #{testpath}/test.py 2>&1", 1)
    assert_match "VERIFICATION FAILED", output
  end
end

__END__
diff --git a/src/esbmc/bmc.cpp b/src/esbmc/bmc.cpp
--- a/src/esbmc/bmc.cpp
+++ b/src/esbmc/bmc.cpp
@@ -3037,7 +3037,12 @@
       note_cov_suppressed_violation(claim.claim_cstr);
     }
 
-    solver_stats.total_time_ms.fetch_add(solve_stop - solve_start);
+    // libc++ before 18 has no std::atomic<double> arithmetic (P0020R6),
+    // so accumulate with a compare-exchange loop instead.
+    double prev = solver_stats.total_time_ms.load(std::memory_order_relaxed);
+    while (!solver_stats.total_time_ms.compare_exchange_weak(
+      prev, prev + (solve_stop - solve_start), std::memory_order_relaxed))
+      ;
 
     // A claim that reached no verdict — a backend failure (P_ERROR) or an
     // SMTLIB-only emission (P_SMTLIB) — would otherwise leave final_result at
