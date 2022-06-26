class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.4.tar.gz"
  sha256 "f1f5adba23c749ddfdb2420e797d7ff46e72b843850529978f867583dbc599ca"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b0a513043c90cdaf37886e77e7e8fd5d26b669ae17a97285709ac2354a0f2412"
    sha256 cellar: :any,                 arm64_big_sur:  "d4848cac56d6ed4199cc562e8cb7d9f03b592481c49ebd7800d865a0c552db39"
    sha256 cellar: :any,                 monterey:       "aa9431c2cecc4b689aa2340fc55049ab389fbd3c3addc37f926c1a928e6068f6"
    sha256 cellar: :any,                 big_sur:        "040a9ba684acb1661952ec2742146d67c92d423a2628e9d19256c57353a62ab9"
    sha256 cellar: :any,                 catalina:       "e1330a26f4fe8c2b8615c7358d99a7f9a7b61abd86575012e51007c7b2a6569a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01136a668aae3151fc5f25bab6f8d3e64c974abf59b57d4628c75834d3f49b0"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
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
