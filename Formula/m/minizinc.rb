class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.3.tar.gz"
  sha256 "151ec26165abfb13d709d89be92b3f9bbb5ba3873b8ecf9d88ac15f31042628f"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f16fbb920305c15ba2df29feedeb3be6cf719cb8ddcc6a9f2c8eb83726189b61"
    sha256 cellar: :any,                 arm64_ventura:  "1669fe4bea10e36e02db72af1a214a5ffce1113c3153735fe794ce552f45bdfc"
    sha256 cellar: :any,                 arm64_monterey: "ac0406db5f6e4938a9107e2eede359be8f92c60900af676467ec8bf6a7f98e30"
    sha256 cellar: :any,                 sonoma:         "6c94413d2e8235d519f4cae3fa0cd8b582ea285848dfef8668b6f718a0e08145"
    sha256 cellar: :any,                 ventura:        "a8685926ef8f4e34f57e75ec5063d9a207b541f92697cc05da5c0f5d953a7702"
    sha256 cellar: :any,                 monterey:       "13a9031a1ff9da632321b0d2d0d1873cd3ffb311d4c00efc28a979b1398eb06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3663e181a5ecbd059199c43c07b30b987ac0ac3509e29a039e74dbc705b752a5"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
