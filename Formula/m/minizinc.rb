class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.3.tar.gz"
  sha256 "6380c8a294232bc3c015e63b5ac247885a3ae0e57badab8e329218288e396619"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256               arm64_sonoma:  "c79b4e639723b668800912165f376351716e7baca0d8b014e9055316e3032b1b"
    sha256               arm64_ventura: "459f08c97a5b1a7ff4e4e3d96a926d01123b2cee146e71406840e6348724c2eb"
    sha256 cellar: :any, sonoma:        "562bcc77b1ecb60f2831f9cf644c7f842204a19c1f2a2c684aed9f017393cdd4"
    sha256 cellar: :any, ventura:       "7a7cbca75502ec6707743977524e1696d4dcd15517daf0520b661270098c364c"
    sha256               x86_64_linux:  "63aa6820b2e56879877f12ca7673b0d8cbb3bcccaf34282051bafc7bbb2ea443"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  conflicts_with cask: "minizincide", because: "both install `minizinc` binaries"

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
