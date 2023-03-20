class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.7.0.tar.gz"
  sha256 "84aa5708f6397b34f9c4eb77079552ee3aa55d30cac39fcaa072832898cc1432"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c71a039539655c1c3504ca6c0ef66a2e85680609e8c5e1c4a2fe3a00bb8ae46d"
    sha256 cellar: :any,                 arm64_monterey: "6e48c1109ffeb9185e56fdfdf86490e38d2bd6cfc4c3bae2de9fa8e8f1db4ab3"
    sha256 cellar: :any,                 arm64_big_sur:  "3ead596a2a7aa0ffe3291f106e521c7f193f1330c902cbf6f5370649d81c07c0"
    sha256 cellar: :any,                 ventura:        "de36b6c809827368642fcffd39e6110d24d042a3d6867e6629aee7bbbd52ea29"
    sha256 cellar: :any,                 monterey:       "0fe808f87407975e11760efb2a6b32af673add52651ffd8684b26ce6149f1a05"
    sha256 cellar: :any,                 big_sur:        "8c9760798b10b64b2c3c965123975703e181714aba4f2ee25dba84d69b4e4410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b021186a0dcbc5f98801c61126b7acac7e3f9c27ceee233c5e51f13816f16dd1"
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
