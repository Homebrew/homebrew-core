class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.2.tar.gz"
  sha256 "1787b352bfad537246fc7278325b1039723b436293f5b90d9c394b696b67da2b"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256               arm64_sonoma:  "1dce891dac1d830a87bf2e1cbd5ea0e62ef4f16cdca70371f8c8612528511bea"
    sha256               arm64_ventura: "f37150a907dbe696da806cced948c75d50d2650b5edf169cb3906f05fef33f97"
    sha256 cellar: :any, sonoma:        "76f11ade9a6b4bf1699dc47929b52d907b5c8ceb32431ec7ec265633a53eabfa"
    sha256 cellar: :any, ventura:       "6485c5a3808c9d82737c8790db4331590eb5145457768be9647147e45dbcf63d"
    sha256               x86_64_linux:  "19ec06eff879436bc33c5f438a359dafb3949b29c76f7db069760573345fa7db"
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
