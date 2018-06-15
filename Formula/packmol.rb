class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.166.tar.gz"
  sha256 "104756d8c39e0ada6c508aa55513b0ef0f9ec944df0f0a8b38673a9edc2d21b2"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "e678fc7aac994290c612090b6b214115891d61a0981b8cd3ccbee4fe0f338fe7" => :high_sierra
    sha256 "e9b717c41d745d3acc1d8e545dd6cd13b3446e498c1230ef116f4759b5e501ae" => :sierra
    sha256 "c1f34206ca69a27f68c6710648be8246c86ca0cca7183701bf0cdaafbde9b845" => :el_capitan
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
