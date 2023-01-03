class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.12.0.tar.gz"
  sha256 "9c8a97f273ce6c6932b209a6c4e01653d02e1194bcb541d513f14b33f4bdab80"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7ae8e230d8e282900b723897bdbb741bdf3a1aaff8582ee1ba863dcb60de19e"
    sha256 cellar: :any,                 arm64_monterey: "7c7d1f78867bdcc96ad187976bd8ac41082e639b21dbcf286bf94228650c1c19"
    sha256 cellar: :any,                 arm64_big_sur:  "fa039b0ae50bbe63b1bb8f7055e7966f41e7f02a4c1d7134f6916c64ea7fce90"
    sha256                               ventura:        "18f85b3d4c964f3fc14e53d0034d0f82d4919f70e421ec2d671e427ddea8e306"
    sha256                               monterey:       "cce33f6c899378e1055aa05d7f87de6a064784bc41f33b87ebefbb81681c9275"
    sha256                               big_sur:        "0ac12ca2e9ae4f83fd5303480cb4d9549b0fa6addd4115165bee90ab4c60ab7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f8a1b6670a2fc0e5276851e3ef65b5d5c1b64b3326789eca565f8dc3a1e3e2"
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
