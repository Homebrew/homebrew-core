class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.5.tar.gz"
  sha256 "cd8aa35532191864ba5a79f8755e0e24c329b1b887305f89d5f7b33eca9f96db"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5d23958246702a4b6d4621322a3a92b287f435ad16f666225f948969bbcb5dc"
    sha256 cellar: :any,                 arm64_ventura:  "fb65c85fedf0ab231c8c1e2d849769afaf14c90e2a072743999a00d045a0556d"
    sha256 cellar: :any,                 arm64_monterey: "5d5c51f5e78ee858602b1773ee83f1bb4c05973b8803ac290a2e17a5c4551717"
    sha256 cellar: :any,                 sonoma:         "10b89259070a771488b6fc5ec478cf824df9ef07f5b47a7987596cd0abd63c93"
    sha256 cellar: :any,                 ventura:        "e49cf5f2558871eb9fcda377c07a4b3edc703b8c0bec2ba848c933fab34b4899"
    sha256 cellar: :any,                 monterey:       "bfafad8ee9e5364fbd78e8b6ba0e41716746c2d18cd05dd2c2587dc0835ff0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a65759339ef50d18651b5d4f28d8da0be13d11f543d5f892c1bfa80667c1f5a2"
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
