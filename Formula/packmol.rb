class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/leandromartinez98/packmol/archive/18.013.tar.gz"
  sha256 "2e87f8ffc24a7a8702baf895a051ad5b5f2dbdebc158ba0235a6f6eaf617eb9a"
  head "https://github.com/leandromartinez98/packmol.git"

  bottle do
    sha256 "96deacd0dca499fb3f577033ceabb122822d44a2060cdc47b02a57fb2358a63f" => :high_sierra
    sha256 "d1948aba64f56109ccfc9e7bedf48950114c6bce751e6f653bee140e6d58a1d7" => :sierra
    sha256 "517f2c6c55adf427b5c2b6132fb3a1ca654057a0b95c46cef33b8ef1cb6cc57a" => :el_capitan
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
