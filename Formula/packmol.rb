class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/mcubeg/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  revision 1
  head "https://github.com/mcubeg/packmol.git"

  bottle do
    sha256 "30eaadfcb75cdfaeca7f10c9ae8b96c3f1a423420a1b1ee8e22bfa86a4f21d3d" => :catalina
    sha256 "3c486c726d2e535fed629ab3db8c09424be37ec11f4f3e75883cb1e5ee315907" => :mojave
    sha256 "2b9a34a4e1fa9cbc1d4b522b1d1cb591baf7e17d25fbb9ded02a636f95e982a3" => :high_sierra
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
