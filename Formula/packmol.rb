class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.103.tar.gz"
  sha256 "2e4bcb232183566c290d66a73b6b29c716eeddd08607b2dcba1e981a40c1dc86"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "0611026821c4fe3fbdfc72dac718064725094c9759d4de694b83c124f744b3b6" => :high_sierra
    sha256 "d9230d3052da6656db3436eb552fac5e5a31c8361c8497afbae94ef870959c29" => :sierra
    sha256 "156944c2a0fcc7b90c3c817241cc3752a5056d87a2559194d8d8a03555111f09" => :el_capitan
  end

  depends_on "gcc"

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
