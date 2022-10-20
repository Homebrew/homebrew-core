class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.4.tar.gz"
  sha256 "f1f5adba23c749ddfdb2420e797d7ff46e72b843850529978f867583dbc599ca"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1e9b22bedeac1d802335797e45a482806b607aa20b1a38e406f10fcb0d933473"
    sha256 cellar: :any,                 arm64_big_sur:  "4543525b1036daa085faff48d9ea158bcb029683f2b207be1f4c86832d1169b0"
    sha256 cellar: :any,                 monterey:       "08544ad457361b71dd8bb8b223d22e4c4ccbcb9dd544d5f706a50a177414ef8e"
    sha256 cellar: :any,                 big_sur:        "90d6a2c51750101f1efc1797de6a0f127b797dda2f502e3673ac23c5ed012e76"
    sha256 cellar: :any,                 catalina:       "8a9e1de8f0b12cda3283b4113ca6e948ef6ccfa1c70a422c009169c0291cf1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb570bd601da0bc9530ae31a44b3bb5817b00726813eaa6f13a75699227cbca"
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
