class LpSolve < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://sourceforge.net/projects/lpsolve/"
  url "https://downloads.sourceforge.net/lpsolve/lp_solve_5.5.2.11_source.tar.gz"
  sha256 "6d4abff5cc6aaa933ae8e6c17a226df0fc0b671c438f69715d41d09fe81f902f"
  license "LGPL-2.1-or-later"

  bottle do
    cellar :any
    sha256 "53e611f8df08011c71022b51b9cab75469e9799f4de457b769f407741ef5fe8c" => :big_sur
    sha256 "9a798c3fc6356bdbae35a8b3134ae5a51a7610c325cdf9f8ee4a3b41b7c1fcb0" => :arm64_big_sur
    sha256 "0275d7331a6b593f84cc59a0f6a79e83be9362404b0b837aac78ce1cbe604ad7" => :catalina
    sha256 "e52d1c29dede6d743305aafd18ac7c6d6ba350d8e6fe32dae3af086bdec59ea5" => :mojave
  end

  def install
    cd "lpsolve55" do
      system "sh", "ccc.osx"
      lib.install Dir["bin/osx64/liblpsolve55.{a,dylib}"]
    end

    cd "lp_solve" do
      system "sh", "ccc.osx"
      bin.install "bin/osx64/lp_solve"
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
    assert_match /x\s+21\.875/, output
    assert_match /y\s+53\.125/, output
  end
end
