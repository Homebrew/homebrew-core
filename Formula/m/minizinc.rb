class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.2.tar.gz"
  sha256 "e8b5c037e1d9711803e05ef6eaf416d5ed080f57cc0867d3c6ec3b1304bfd375"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af60114ce879d772745fd0b89afb6cc02c601d11ea6db39340288c365cb3fd29"
    sha256 cellar: :any,                 arm64_ventura:  "7041c22ba354728d3a49281206a0c5ab6eb669969c44ad040f1a3bdf2cf8599e"
    sha256 cellar: :any,                 arm64_monterey: "aeb49b566f0e847bf6b19407ab0d4f090a354c3e660507b92cc7c47cd0a36005"
    sha256 cellar: :any,                 sonoma:         "e21ca73547975ddc5ec3ce3fa945b9969a6d3f4e406092b2aedae195fe49bc6a"
    sha256 cellar: :any,                 ventura:        "f64e4fce14cfe490cb95eaef371460f24905575a9621720baffcb94dd655b290"
    sha256 cellar: :any,                 monterey:       "091c30d04d904a60eabd98bbf4b153b71111c3afe37fdae07ed40d7bb9a70a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "571e0b5272272b599e0138ee9b82063b062ee34cb2785e9eb6b315d7385abf7e"
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
