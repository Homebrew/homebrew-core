class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.5.tar.gz"
  sha256 "7011b512dad0967c5a7ba880152f4cecdcbe2b96abf5cb078dd676893c1065b3"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "b20d88d4fbe436a6438e796a9d0ee37e9b2aab540693516df2d9f29c7966b266"
    sha256 arm64_sequoia: "24137b35c5ae38d1412564b5deea74e56c1e5a9e77502410a98d53cad0660231"
    sha256 arm64_sonoma:  "785ece906ed28c3b6ac6980dc5cde640a109a48fdab7340cbb0f7598e1f57fb8"
    sha256 sonoma:        "9d7b55fe7b667e34a595393ad4b1382158f64c20b564b6fa0179ac9de7c07587"
    sha256 arm64_linux:   "a4e9507690829a4045d363b26d681760fbcc8f92c0e848a87ae31dcd0a3021dc"
    sha256 x86_64_linux:  "a33e2a3115c58200db5d825ad5cb3e931614671d8ee82fca01543cade180ccce"
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
