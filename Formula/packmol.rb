class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.14.0.tar.gz"
  sha256 "dc39d3c8676c48cf4999a864e902532b664063c616aeecae1962d37478c5a30c"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ef5d522841904d35802844f09307b3dd43d8eb72d9e1239f2ff37520be9d429"
    sha256 cellar: :any,                 arm64_monterey: "f2f6651bda8acf282a8fe240cd7368d7829f19d6c0e9483c38b08653c9f7e04f"
    sha256 cellar: :any,                 arm64_big_sur:  "a3caacce15e4fec8a95641d25f5137283d638232fdc7f078a81e14e3f77454fb"
    sha256                               ventura:        "7caa65f7d3cc7b13bdd7f27e73dd0e72e781ce346760865900cec3ca421bc50c"
    sha256                               monterey:       "ae8246364dd7f986d7a71ae1f5552b1bf443a9333645a386acf2e7106eac10e1"
    sha256                               big_sur:        "268cad2039cab724ed5b3281380c130f98795eb664a68e813bda48a03c3cd2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d578c3a1209866299ba2e8a0679e149ae7055f352524df10f3f7d1462e78ede6"
  end

  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # Avoid passing -march=native to gfortran
    inreplace "Makefile", "-march=native", ENV["HOMEBREW_OPTFLAGS"] if build.bottle?

    system "./configure"
    system "make"
    bin.install "packmol"
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
