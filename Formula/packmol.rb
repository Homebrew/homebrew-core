class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.14.1.tar.gz"
  sha256 "ef66a006f16dab57a04bd5d6238217f9f969dc99931d56e01f93f1c11dc710db"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af5affda54fe6ba5186ba96e776a1589bd9ae1a4055cee1529d2dacef43bfde3"
    sha256 cellar: :any,                 arm64_monterey: "127050c19a5e9f966f2e114772e5fa1388d3913e0624bce2863d19012a0c8a39"
    sha256 cellar: :any,                 arm64_big_sur:  "97e2b341c24e9a04ca5c6fafd840260feddd426d151ccf7c608e44c6cfe8069c"
    sha256                               ventura:        "25270c9fc5beb270109e05dd33a5831fbff0f170ae6902eb03095ec666b0345b"
    sha256                               monterey:       "9407865cb3b61adfdedd1664ed03bb59f125d075558f3e361b6830887307fcbf"
    sha256                               big_sur:        "c557cea410ad5a178db1e76c8510e18badefff108d76d26ee94d63f02d446c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c423fd17f190c050ae1cf9ce19e09c207b5b1214874db5e55f4a352756c3ca0"
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
