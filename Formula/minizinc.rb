class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.7.2.tar.gz"
  sha256 "edba6eb389f9afd6ba84c35fc57970174c71bd48642599276ac0d3dd9a9b931a"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f0080a5a3b6787ca01bae4c040bb50430c5821c8d701054b5e411fe81bd892d"
    sha256 cellar: :any,                 arm64_monterey: "876d7c8e06f0ba9fba762b70ae3b9a94eaf04803926a7e4df21c2a3f3117838c"
    sha256 cellar: :any,                 arm64_big_sur:  "6db3a106ef05f6d305f0cc83fce8c5baae3d193f5603ab8b6bfeed6b03d4b6b0"
    sha256 cellar: :any,                 ventura:        "057bbc313fa7d986561b4496e08683f997528e1c976ae75c5a7cefbce140b3f7"
    sha256 cellar: :any,                 monterey:       "8d4100f71e2116d8c43c4df99c4f4cf9753df1249238a4b3f1a7e57863be2f74"
    sha256 cellar: :any,                 big_sur:        "3b97e8b9e93fe151f71fa469df013455bfc1423545251502333f71a1ed85c4e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8597e19e7fee168b1fa6684219eefaac121e5bf021f91953e38c606c6a3ff62b"
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
