class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.104.tar.gz"
  sha256 "a87cb076f82a5ee94206b7534cd790c243fadd2d64bca5b12aa88493d5024f87"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "ae3a96ca2b9e9c2569f14b5e88e64c9d38f8fefad2369e9eb6873eb805190db5" => :high_sierra
    sha256 "cad4f11bb13d0b5ff296f6dd91e8f79d31dacf7e6020d582bb5930c07b301a28" => :sierra
    sha256 "4aeeb7e3b5a0fcc39a37a80b00ad27520c2852e138a48174d8d60980485faec7" => :el_capitan
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
