class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.002.tar.gz"
  sha256 "c8e70e314bbbc327f2b6c3e407101d219a4a8a016c09fe808ae2649536165fc9"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "a0356e819992dbe7b4a0d9c57c4e4f4dd49f61ad84111720549ccc00364b5706" => :high_sierra
    sha256 "0a3941940fd3e86eb17846daf14d9c0f5816f5cb7b1e4f1f94dc7e6e349d8fe4" => :sierra
    sha256 "c407ce4267f46650484760f66a205dc4d76521676ad08c6913cd34a4d5809f89" => :el_capitan
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
