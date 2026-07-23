class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.4.tar.gz"
  sha256 "9959fef848ffae597adac6fa2d74063f9553b4fcee93ed7cbe8aae3bd667bf91"
  license "Apache-2.0"
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3af4c03ff17f500a60eea1f8d5da1c30faa0f6e6f0c38f0371b3c7652a1fed4a"
    sha256 cellar: :any, arm64_sequoia: "32cde20694a0a616eb2d56f406e0d591f04450e2e761a72281ce3067110a2c4a"
    sha256 cellar: :any, arm64_sonoma:  "7546099124315984f71bd91f1ec806c9df29e496e577a99197930b056081b6ea"
    sha256 cellar: :any, sonoma:        "fe9b699426ce6f7412dea4ca508e6aa4fdd66780559928b27c29a6220a81c09a"
    sha256 cellar: :any, arm64_linux:   "856d81d31adc463a32286f5dd4142a679926c5f6bb2bfc0c64c9cb8b4afbbef3"
    sha256 cellar: :any, x86_64_linux:  "8b138269e4f82ba2df1b4b89c7e21cb6a7ebbc07e8d69eae394590cfda09954a"
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
  depends_on "llvm"
  depends_on "python@3.14"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  def install
    python3 = which("python3.14")

    args = %W[
      -DLLVM_DIR=#{formula_opt_lib("llvm")}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib("llvm")}/cmake/clang
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
