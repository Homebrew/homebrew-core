class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.10.1.tar.gz"
  sha256 "089ea94698cea94ed8396be77559b82d828437a808f5e37d10bccc9f1d39dd33"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 arm64_golden_gate: "7ce8ae49a7159112321f619709aadca67bbc8882d1b97b6e88e317849fdcffbc"
    sha256 arm64_tahoe:       "0e399701db20c046b319387ab97f0928136a89b83401e939934862a0585d5f97"
    sha256 arm64_sequoia:     "6decd5eebaa54328910cee5a32e580db6b0424c0b58c71d9044558f8ee77913c"
    sha256 arm64_sonoma:      "981041ddb6bdb98f0b7d7cb52d81d291603bae2145d19aa399851584eca7f25e"
    sha256 arm64_linux:       "33ef0af1f067f0cd1a6141aa2b5b17fc7d85a9aebe03107d6125ef3e8efbe29e"
    sha256 x86_64_linux:      "c5c6631aab467d49232e52fee307c7bd641b0ffd6222887243abed1500c2820b"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

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
