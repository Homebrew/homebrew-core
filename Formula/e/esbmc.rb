class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.5.tar.gz"
  sha256 "61a240ca75cccbd037292d4921b7da01bf12fef0ae760401d3284a3a8a17cff3"
  license "Apache-2.0"
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e68de291105aa20234dc7c4e0e183a3aba97adcfb21d1bb35ea800fd71b80c87"
    sha256 cellar: :any, arm64_sequoia: "b2a53e3b9cda8686172c29e024aad0e3a72ceaadf5b3e5b83122193ac8c0cdd5"
    sha256 cellar: :any, arm64_sonoma:  "d34d9e0e0e71904a292c67c092b4c3fb67639cfb447619de7649add8f8e108dc"
    sha256 cellar: :any, arm64_linux:   "f3ea238a336821b8b5838b10b4e6816de28d671a77ced0897aa416dca77cb2a4"
    sha256 cellar: :any, x86_64_linux:  "c7b61f6235775dc0bc8ae4ac0cadf2827dd623ef0ae789a651a68e4c38889ccc"
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
  depends_on "python@3.14"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  # Avoid std::atomic<double> arithmetic, which needs libc++ 18 or newer.
  patch :DATA

  def install
    args = %W[
      -DLLVM_DIR=#{formula_opt_lib("llvm@22")}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib("llvm@22")}/cmake/clang
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
