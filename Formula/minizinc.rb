class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.7.2.tar.gz"
  sha256 "edba6eb389f9afd6ba84c35fc57970174c71bd48642599276ac0d3dd9a9b931a"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebe868f7f13a332df10006c65a8b8f1f12d7eb9451b3a1357af86297a284dfb5"
    sha256 cellar: :any,                 arm64_monterey: "291019320cb539c0274151526be048280767a58fe6c02a0099ccab4fdb97103b"
    sha256 cellar: :any,                 arm64_big_sur:  "ad7c5535a677e8f23c8052886f430eda9749643f6d10ab1a4f2faf3281e8af74"
    sha256 cellar: :any,                 ventura:        "62625cc64a53039518d7c3d2735a41536ae0836acbcc9900f276284484434d85"
    sha256 cellar: :any,                 monterey:       "c549d9cf804b1166a2083d7443c490ce252610d48b8d4074a0e2d5776ef9ec61"
    sha256 cellar: :any,                 big_sur:        "222bb163e950c00ecdc842878ac3cc1ee3333525d0e6576012bc902d702769c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e8bdeea0ce7aaea2ef40d2894bce3ba78cc5357248f0ca366db402eee5abdc"
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
