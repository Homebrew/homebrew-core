class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.169.tar.gz"
  sha256 "8acf2cbc742a609e763eb00cae55aecd09af2edb4cc4e931706e2f06ac380de9"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "5b66edef2e722da0b565bdfee29df4dac53e43f20f94d7e02ffc0e8e7adf3443" => :mojave
    sha256 "74e54488ffe1f078f2e703f475e20639c6de5e518b8c9c010c29a2a74786bb10" => :high_sierra
    sha256 "32e6f9cc2f6d4e010982e63b5e316afe3786f38e4a5bb5b6ff1908815cc11192" => :sierra
    sha256 "ca93be32b9abda9bf4c6a7f70404122108f66e1199da4e979cf96be37d1e34a6" => :el_capitan
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
