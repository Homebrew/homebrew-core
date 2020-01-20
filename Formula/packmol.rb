class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/mcubeg/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  head "https://github.com/mcubeg/packmol.git"

  bottle do
    sha256 "f2ecebd27ee7b115271c5361cbd8769dd5e8bf0fa8dc69fdd66a907bd4af6318" => :catalina
    sha256 "cf9e09622c5693667366b71ac09c0a1dcde7a66994ec5fecaae93c4187032667" => :mojave
    sha256 "7dbe01c4cf358d1183fcb8ca26e8289c20f8abd6ce04f078471eb34c65a0b204" => :high_sierra
    sha256 "c4cd96908626a8f04e3f9e0858c15deec9baa1841c1239fdcb08bd582f5acad1" => :sierra
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
