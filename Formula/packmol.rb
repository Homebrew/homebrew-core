class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  license "MIT"
  revision 2
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18c206884bbd5f5f14da86468f1dbe2d54fdeeca1f2990d8abdc2a190b03d7e9"
    sha256                               arm64_big_sur:  "3d43d73153e16a136bc8c222e38b04b564d974de27030ea6bc07a854e801b837"
    sha256                               monterey:       "03079a57621d3b6e0eee72d3d4a6492dec0504076f428357d9d8eacc41d0294f"
    sha256                               big_sur:        "5e17a008667df7e5bc6bee6d5563dc3972c3f52b4243ab2d92507be35ce9d12b"
    sha256                               catalina:       "3ab1f82f9882aeb3e7fe733e7c375902bb5b9ced8573fcbc90913fcf19407c9a"
    sha256                               mojave:         "d881b332e102b00f5ebfd5f48ad10cb80087a0535d919514fe766e70e7fdf4f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "651ebcddfe87e6a20289190f63d3f51b8d0e002f41308ae517b28913be823590"
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
