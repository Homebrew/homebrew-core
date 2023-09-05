class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.14.2.tar.gz"
  sha256 "9b7647179bb3780f0df7bad866ada346d7cb3f67576199f95b654fe833e728a4"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3b983af8b2e95b1382462ffe464718147f43ee0a589962ec59c3e40ee99a37f"
    sha256 cellar: :any,                 arm64_monterey: "e69c747e0218728e6db1857e70ed872ccb40382ba6767fbc452afd9ca1aeb891"
    sha256 cellar: :any,                 arm64_big_sur:  "c2e07dd1f235047d3bb96d27afe8065c33f0d117d614cf983d824bcc4c1c225d"
    sha256                               ventura:        "7ae04b000294196fa456309860aa8a608a6ebd1984623eaf2bd6d2da4b3c6755"
    sha256                               monterey:       "f97bcaeb053fc51f43ee3e12c0fd931150fa6cc764401bdc61cefcc8279d53f2"
    sha256                               big_sur:        "3561870306303c91c377f240cc754a1f0dc362c3495e8bd44d0629550dd9c066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5a1a48a91c5c51e5cca78f64da59cd75cb440beae29608354072558b9e59c2"
  end

  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # Avoid passing -march=native to gfortran
    inreplace "Makefile", "-march=native", ENV["HOMEBREW_OPTFLAGS"] if build.bottle?

    system "./configure"
    system "make"
    bin.install "packmol"
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
