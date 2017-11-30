class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/17.333.tar.gz"
  sha256 "9b8a73f3ce0cdc7ad554fc6ece1e46ee11ad5803153cf46d3dbcedcc65a1d55f"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "ad82a016da674cba104db626e71a10069449c580f687fa925668176d97f214be" => :high_sierra
    sha256 "447c2060019f52d192080449efac203fa0ab61cf3f94e88098008f729c8c0188" => :sierra
    sha256 "c870b673a5b70562a410b22b30feb39a3d7a0ce00e6223cc85602f96fe2b5fd5" => :el_capitan
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
