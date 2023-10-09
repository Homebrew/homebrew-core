class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.7.6.tar.gz"
  sha256 "99de3a1051bd4b3ed2d436f62d965fce067286d954b5693d74a5f7c75877ddfb"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3da7cd1b53a64b537dc86c93fe99bdaea45ac6f9816c6510d016878f5562d1be"
    sha256 cellar: :any,                 arm64_ventura:  "8460d8a0b90090470604182e9aa931208d19236e4a4e857fb6a8d8bb6a62440d"
    sha256 cellar: :any,                 arm64_monterey: "cd531ac0c9ee3103e0049c864cc839537ef4c8de15b5c6e1b756e10272cbbfe4"
    sha256 cellar: :any,                 arm64_big_sur:  "276493b57d3727f71fa964ab28b935d95bacc961c8cc3b4f3ff7c1f1a40d1a7a"
    sha256 cellar: :any,                 sonoma:         "e88621801961dff95c34b0a2621f1c1797013c79965f27991a3113d252e4f045"
    sha256 cellar: :any,                 ventura:        "29e7a31c4fc563fece105bd047b6a64add3a410b49b5589ab3a7a30578446a2a"
    sha256 cellar: :any,                 monterey:       "3147a04982dc51599f51a1604f5ac6ec4a24ba7482824c44087e8a52f4ce0ace"
    sha256 cellar: :any,                 big_sur:        "f60a8a6ce92b70c92ece762d49407deb6a54a6b48216be0d8ca9410354292e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce0bc5c4b244b6951e0f89ca1387c05b19f7d18dffd5340acd4affa315d3be34"
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
