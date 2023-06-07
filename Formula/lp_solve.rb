class LpSolve < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://sourceforge.net/projects/lpsolve/"
  url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.11_source.tar.gz"
  sha256 "6d4abff5cc6aaa933ae8e6c17a226df0fc0b671c438f69715d41d09fe81f902f"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "94b01c00f2c0fab83fef56cf4e1cfe30e400db29e33007cfcf0fa95a5737df2e"
    sha256 cellar: :any,                 arm64_monterey: "e496fe2ab54f35a44e66c68c54124260554b23194f38880fa934ff20d5a17b2b"
    sha256 cellar: :any,                 arm64_big_sur:  "064364e4edd599066792e63f44649f9986d3b3ef10e83b91c68d756aaac2f543"
    sha256 cellar: :any,                 ventura:        "d25c84ab6d67b5d6e223179202b5a07fe41825ab550205739d20173b948d6ca3"
    sha256 cellar: :any,                 monterey:       "4f875e5986e06b7b231f9f9ceb797becd8ddd04acc040097c82284efba44cbff"
    sha256 cellar: :any,                 big_sur:        "04e8e54a2c3c58d7430337dc2b0f9ca6c2db2d144bb98a6b91312cd63faf834d"
    sha256 cellar: :any,                 catalina:       "ac4e07a9e144e2ef6ed34e340a9d9eb769ae7184723df790a8b78ef32d46e753"
    sha256 cellar: :any,                 mojave:         "4abc54efe795496f3114edcdaaf3b90e55632bbe92c5816b5372b9743366e62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866347d7fd1625067ac3643d61249354dbe64c38fc9028f0e0a576968437460a"
  end

  def install
    subdir = if OS.mac?
      target = ".osx"
      "osx64"
    else
      "ux64"
    end

    cd "lpsolve55" do
      system "sh", "ccc#{target}"
      lib.install "bin/#{subdir}/liblpsolve55.a"
      lib.install "bin/#{subdir}/#{shared_library("liblpsolve55")}"
    end

    cd "lp_solve" do
      system "sh", "ccc#{target}"
      bin.install "bin/#{subdir}/lp_solve"
    end

    include.install Dir["*.h"], Dir["shared/*.h"], Dir["bfp/bfp_LUSOL/LUSOL/lusol*.h"]
  end

  test do
    (testpath/"test.lp").write <<~EOS
      max: 143 x + 60 y;

      120 x + 210 y <= 15000;
      110 x + 30 y <= 4000;
      x + y <= 75;
    EOS
    output = shell_output("#{bin}/lp_solve test.lp")
    assert_match "Value of objective function: 6315.6250", output
    assert_match(/x\s+21\.875/, output)
    assert_match(/y\s+53\.125/, output)
  end
end
