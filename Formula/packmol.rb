class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.008.tar.gz"
  sha256 "e42e15a1cda80d69ba5f8419126df78dabce3037e692a23abc30eba9f200dd17"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "30074ccecc3a1086a925a4ac4ef679c658f0e893d99cd192a6fb75d7e3bf1359" => :high_sierra
    sha256 "96f907b693394e52f9e7d5b20754d13c7b17aaf73b932b798bb601623b46780d" => :sierra
    sha256 "0ea1df64f15e6526737b75a982a3cd2bf4becc609ffc0b47e73658a7c7fff8e8" => :el_capitan
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
