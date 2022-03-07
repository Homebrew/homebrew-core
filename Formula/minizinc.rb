class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.5.tar.gz"
  sha256 "c6c81fa8bdc2d7f8c8d851e5a4b936109f5d996abd8c6f809539f753581c6288"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d01255d2e723ff34ac50f7ebc757d76a8c20a7429b5a370f274013ce9213f241"
    sha256 cellar: :any,                 arm64_big_sur:  "2b42bf0200d3994836e19b182071d6e01356d73a142f8e05cb0262503a51388a"
    sha256 cellar: :any,                 monterey:       "21face194a18f55c82a3c556a752fe346d15261021c036d8325b97eed34a25ad"
    sha256 cellar: :any,                 big_sur:        "5b5cf302b7e196dbfea011879a2bace24d9991f398cc243e4146e3500565ec30"
    sha256 cellar: :any,                 catalina:       "1a3f200f314c8f89090e5bfbda0e241023a5efbbe17ce0ee67bcc50d0edd3138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a190fa33d43ac9219a8b13cf3ff23eb7dc2db83d457af2affbc8eee172db03a"
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
