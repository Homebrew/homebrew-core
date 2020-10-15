class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/mcubeg/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  license "MIT"
  revision 1
  head "https://github.com/mcubeg/packmol.git"

  bottle do
    sha256 "2de3ad79e6630d32fe68ac901ab113ba8ae3370e1976909390bcf4eb76a9a1d9" => :catalina
    sha256 "2db13531577dfafcaa3d654a714e0c44503049b968ae3f6622baf3d53933afec" => :mojave
    sha256 "ccdde7eab41ce8847bc3fcabdb482c68ea3f39c029abe0c146ec9ea370c97bfe" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
