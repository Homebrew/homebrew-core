class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.5.tar.gz"
  sha256 "c6c81fa8bdc2d7f8c8d851e5a4b936109f5d996abd8c6f809539f753581c6288"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "051a8da67510e17e57371dc332cc441f80b366affce08917173b92fb9c7e047e"
    sha256 cellar: :any,                 big_sur:       "65127ebb8476ee303b45624b7e7a7c9e1f6d4b740056b95c31da6350f819ada6"
    sha256 cellar: :any,                 catalina:      "921698a98271c69f66d66303be5e6852b083e4117a349f4039c482597b863039"
    sha256 cellar: :any,                 mojave:        "2ffec6708a7253410c073e8faa5e8dceb43ddee2d1002beb1032f31c8ee4a492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593d73ddea77194856cba87bd7a3b203f465b13a182769965a7fad4a5435ac09"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

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
