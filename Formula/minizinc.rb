class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.3.tar.gz"
  sha256 "07982723009fcb50ae190bf17277e8c91e6279f319521f571d253ba27e2c2b1b"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c54e2022738c39dd339bec62ba9d933b5b44fc07587c51361492cdfd5a961db" => :big_sur
    sha256 "d3e7df985149ff4c1b12782a94b0ccfb5d862dd3e186e6c934d6e9d70dc21c3e" => :arm64_big_sur
    sha256 "2ee5718af0ff50473754355384284e29162d2dff60c7b433d312c9cef0e21ff0" => :catalina
    sha256 "9d2af2903a893c0dadeddecbdbbdd2fb55fac3b1f37364881b4648fd90c037b2" => :mojave
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
