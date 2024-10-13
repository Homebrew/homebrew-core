class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.7.tar.gz"
  sha256 "91413c9788d45eb77ecb1da9657c00744312cca4fd5e71ca2583c35a32a3be62"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13c0b9e11d12f00725a0d3877a48fd8738d1055f545ff637496dd9c60cf451e9"
    sha256 cellar: :any,                 arm64_sonoma:  "4471139edeb08c57ef898b371543ccd1f5dd7e92edd485b2db5aaa1719431efa"
    sha256 cellar: :any,                 arm64_ventura: "1a640fb1b353c20683c31756a63dd5da5b7442e879481efb0082b234f4edf522"
    sha256 cellar: :any,                 sonoma:        "713ee39dbb00cca35b673456b7fda516fcef1014c9615cdfd66df9ac8e3a2768"
    sha256 cellar: :any,                 ventura:       "9fbe354f2b789bc9f3b1311c2ccbd03e13fd361001e297e3e50975903dae150f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11caed387d09bf8b91e0aa053bb333bbf6276adefe72d962c5d2c0b5151d679a"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

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
