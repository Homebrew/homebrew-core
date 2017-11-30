class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.333.tar.gz"
  sha256 "9b8a73f3ce0cdc7ad554fc6ece1e46ee11ad5803153cf46d3dbcedcc65a1d55f"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "506f80e05a8cf958951d886a59b623b80ce4c590dffa2e906cbf593f57cf5ca6" => :high_sierra
    sha256 "e18dea57a113401f7bccd34799e11c70560112c3fab1364bbac200b8b73211e4" => :sierra
    sha256 "9b7c37f880590542890871c5527299a155dc28385698e71c97e39d13603c353c" => :el_capitan
  end

  depends_on :fortran

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
