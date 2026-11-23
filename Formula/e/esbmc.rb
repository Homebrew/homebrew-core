class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.7.tar.gz"
  sha256 "594390f0c8520119f26cadd295419488c0824664ca8b251dbd5dfeade9fc3481"
  license "Apache-2.0"
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3a47196e1c1f5bb58fc9d1479e87874d92b959c5278325252240cf21798a0d74"
    sha256 cellar: :any, arm64_tahoe:       "8143eca75e3c8ddf8a3541ed7933f58a0710a159c3528dc697830845c3e5d38c"
    sha256 cellar: :any, arm64_sequoia:     "38c28775710393af3a5ab299797a4e78485ba4d3c2fc6d950266d27f55884928"
    sha256 cellar: :any, arm64_linux:       "f026ec2977b8029eaab0b03c80d9c1a7b8a621a68015c9fd94031555ffe4673a"
    sha256 cellar: :any, x86_64_linux:      "1d40ae76f073b8e22e7a3e864d1df93d15c4e48de3d6c2306a20a6b199470a5a"
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

  def install
    llvm_lib = dep("llvm").opt_lib
    args = %W[
      -DLLVM_DIR=#{llvm_lib}/cmake/llvm
      -DClang_DIR=#{llvm_lib}/cmake/clang
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
    python_libexec = dep("python").opt_libexec
    bin.env_script_all_files libexec/"bin", PATH: "#{python_libexec}/bin:$PATH"
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
