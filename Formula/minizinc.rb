class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.3.tar.gz"
  sha256 "740884d4eb8e7acf366efaad82efa0ca46dc4342afa5a6ecc1d749fcc4f96dd4"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b55a016f4865ac6a319b6f52b3b2a7fa3ae4aa90b6d9931a9a6304dbe5c538f5"
    sha256 cellar: :any,                 arm64_big_sur:  "bc02b6889bbc11f528678cf89ce6a92e3cecdcf8479988407211d9bc65b2d016"
    sha256 cellar: :any,                 monterey:       "1995a81599adbd8ef24889b3518d9f5a9d51a6f7cce730195ec36d12d813e460"
    sha256 cellar: :any,                 big_sur:        "69198098a3ce3e1d63e632eea9710241269ad6aef086c9382815f81235a2e8ec"
    sha256 cellar: :any,                 catalina:       "56ef2b32d0e0d47b52587a1116285fa773978b57289caa8636c9cf5a6280ed59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4676ea1ccfc234dc032dda36e071f4fddaaeff6aacd12f07b6e6c69cce990a44"
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
