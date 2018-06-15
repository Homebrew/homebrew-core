class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.166.tar.gz"
  sha256 "104756d8c39e0ada6c508aa55513b0ef0f9ec944df0f0a8b38673a9edc2d21b2"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "d524677b620eb37e232a91d2b8dac99bb33e2fd286ed7abbf9b38ac5ffe61c8d" => :high_sierra
    sha256 "d2d1320299846a5ca294619e6167ef26de456ce7219064b58c6fe93f3025d7ed" => :sierra
    sha256 "c9328104bd3ff68e826a265adaff9b1977e2a21d619052d3089e5a08ae4b0b44" => :el_capitan
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
