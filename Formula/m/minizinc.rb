class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.4.tar.gz"
  sha256 "855c8e9765f95520c668a9d3bc78abd23dd652016bd8d384f2d94fe1931209b6"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28b75ed657f42f48949090983a7ad4c15d2dcb6f3cebe4bf7f022e9ee64754bf"
    sha256 cellar: :any,                 arm64_ventura:  "3f89adeef004545d988fbbdc5b57fceef05c5a65345bd5d996bb55142b4bbb16"
    sha256 cellar: :any,                 arm64_monterey: "c48a3528cc0b0fbdcec2330da935f57c44f41475c83b93fe6ce373293230397d"
    sha256 cellar: :any,                 sonoma:         "ba5ce600261735f055fe55c3a41b9797a3f51c6057a3b35319f637f7575b3dc0"
    sha256 cellar: :any,                 ventura:        "c16ab0964196fa0db9fbae8e43c9fb43c9097991fc18dab668d4002761ea3d37"
    sha256 cellar: :any,                 monterey:       "474e52bbcc01e8673678e2bb267de8e00b746e96a9cb2542e0a85e7606d1c816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4372d416c4e3f731ca5db2ce62380f1fef8b9440d5908e1153a2e4f86da0f6"
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
