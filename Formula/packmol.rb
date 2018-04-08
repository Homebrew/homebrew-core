class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.097.tar.gz"
  sha256 "4937b558bc72630076effc6aa05afaa5af0cdca7ca81760da4ccb8f7b63158fa"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "70a793e4f58a96e07a318fde7e8c7e54e201bc2517dddd35cf46d7acdffbdfa8" => :high_sierra
    sha256 "c32dffbba6805f29993accf6ffb443d820983bd14ede726d28e26c96b7e1b329" => :sierra
    sha256 "84debb1ba027f86131d4d7152ffd3210544016a53a695e826a33b8da4965ba01" => :el_capitan
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
