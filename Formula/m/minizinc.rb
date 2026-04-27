class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.6.tar.gz"
  sha256 "594cef7419c0c2b99c8b129f079ea7f960e7207a27d16831d82fc074796230b7"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2eeea6e540730678e2230047823fc9e3fe867e1d481447d501fcbe03792b0878"
    sha256 arm64_sequoia: "7cbb22c6dd4df5c1f2e732a2ea37486eedb4232f93772ad96b7509eb25ab4319"
    sha256 arm64_sonoma:  "6f2536caf2f181cba810f53be069ee1b694bc457ffe97fd8689d877ceb7fc3d2"
    sha256 sonoma:        "fe8f424bf2c129df5498e6f8fe2c9324dd0c9252c407a7aa07f59c068950d3c4"
    sha256 arm64_linux:   "19e54732614343ab3e22ae2261e582700fa697bf034c6183cbc8772d40ee6731"
    sha256 x86_64_linux:  "6f1d7199b9b5746d7393a5f7ff65618161238457d929d7f995971daa528b29c6"
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
