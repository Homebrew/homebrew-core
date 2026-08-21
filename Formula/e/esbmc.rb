class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.4.tar.gz"
  sha256 "9959fef848ffae597adac6fa2d74063f9553b4fcee93ed7cbe8aae3bd667bf91"
  license "Apache-2.0"
  revision 4
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9b364b9779d8c84beb79b10806b0635f3abaed58f2748869085b185ff93c787"
    sha256 cellar: :any, arm64_sequoia: "b1501e2be91fe3317f95016510e12a0dcb3dc3c1c2e92af180ff36bd221a01a0"
    sha256 cellar: :any, arm64_sonoma:  "0a1f50bcaa9171da3b8d272253c05c84d9516710bd17b570b0c67bcc784247aa"
    sha256 cellar: :any, sonoma:        "81bfad135da43fdea6c9c893a5449ee1c5e0989c2849db601e1c0a9e8616d575"
    sha256 cellar: :any, arm64_linux:   "750acdb4b29b89de8730a6ee808312e232f316961ded4388ffdbf74356d85c52"
    sha256 cellar: :any, x86_64_linux:  "de000804e238d5cc8d3c72708337c1de905be2de39a8d50ccbd6e5abc2f75e71"
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

  def install
    python3 = which("python3.14")

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
