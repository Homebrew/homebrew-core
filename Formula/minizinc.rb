class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.7.5.tar.gz"
  sha256 "888ade5d682f6d7463d4fb0e408e363b9928a280843f33f6b5e124045e25ec0d"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20245c6dd7b4d0e37b664033bfc955b3e1a19e62bb896fa48947d17ad2e7a459"
    sha256 cellar: :any,                 arm64_monterey: "6f69dc96b7a828dfe9b71bc43a3bf95610d7ab99ade2aace3ee7d894fbbe750a"
    sha256 cellar: :any,                 arm64_big_sur:  "02e7d120c67d485417c5581bb45845be8dfe569e4188807f50d45e1eeb351c51"
    sha256 cellar: :any,                 ventura:        "12ac862e4ccc22ba396ca04b6cdd67e3d3d72e6563d630a676e7c996f9891e6f"
    sha256 cellar: :any,                 monterey:       "7294ba9e043bbacd8f0d952f16c803100fbc45d12c48ed5c36e990c2a99dbd68"
    sha256 cellar: :any,                 big_sur:        "f2f4141b78d4fffd8200cd2426b0e046dabc049bd05fbce7e4d04e87e766465a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cc6f9e37e457c67e9cc45a1ca70adc3a5dba374767407ba1eaab184c56b97f"
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
