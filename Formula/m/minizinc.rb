class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.10.0.tar.gz"
  sha256 "a71d1359dda1bd68e9946e5c49a95b44c4aefd6dc4654cae769097c28698be0e"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "bf8757ecc8da237cd9db86bb4bcfd404919e67c5953ba29bba110839c7870968"
    sha256 arm64_sequoia: "7056040949003dc9895e7db5328152ff49217905caf8624383d094817b69a423"
    sha256 arm64_sonoma:  "d963e0e9c5c3fced1f63fa5f250d0c3a18fb0377054f3624d19053d97a02ebbe"
    sha256 sonoma:        "b12b5fa04f9d5d77cc2fca1ce2afa089cbe42b3ec4a8b86bc10cbcf75cad556f"
    sha256 arm64_linux:   "262e1db8b08867e9abdd5c4148aac46aa7130ec1be2e17d4e0178bee7196ee69"
    sha256 x86_64_linux:  "b0a0a7e524b2753bbf24dbd3883e46aa4b76f5ccf21b95ccf47d0ef8b279f99a"
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
