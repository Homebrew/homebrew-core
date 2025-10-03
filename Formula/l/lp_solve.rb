class LpSolve < Formula
  desc "Mixed integer linear programming solver"
  homepage "https://lp-solve.github.io/"
  url "https://github.com/lp-solve/lp_solve/releases/download/5.5.2.14/lp_solve_5.5.2.14_source.tar.gz"
  sha256 "a4bbdc881128bdbe920a38e134c9add5db47f9aa814a0a018ba940b0f3c278c3"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b381a714eaa25ce7d9a31b7150e6198580f8dec50e2959447303ba44513f86d"
    sha256 cellar: :any,                 arm64_sequoia: "c691e3169ffcf1b21b222b4b753515d0b9f6db5b52fee6be1e33c9f503cc8a7e"
    sha256 cellar: :any,                 arm64_sonoma:  "db3b377573fdbe36eb96425b13543af4a78680e4f5c78458248a7c30267d67a9"
    sha256 cellar: :any,                 arm64_ventura: "29a989c9e582ee823f481626da3c6034292747c4460305bf6f652a7c83c53001"
    sha256 cellar: :any,                 sonoma:        "e90df62cda38675941ee970bf8d8b097dd6f7bd9db7cdb121d3e8043729f2267"
    sha256 cellar: :any,                 ventura:       "25709d6fd6b005147261b08da92b465e72c947ced634acc4243b96529779ec9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3c72e665dc3028438b1c3edacd247a7697471283a38c239219fcecf59d9d7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118aa8d10143b14d6bbb0479a21702c256a9d891d22e0d937430eaee09478b65"
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
