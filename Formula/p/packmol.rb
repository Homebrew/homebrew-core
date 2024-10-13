class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v20.15.1.tar.gz"
  sha256 "bee21629379d2c5cd463f6350094057f8a85b990ab882b822149a9bebe5bda8a"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "26d0b1ce6e1fc2f15521e20eb59b7d3ab152d245c06da08795a78e4e01e18857"
    sha256 cellar: :any,                 arm64_sonoma:   "408485cc73e8565c80a07a577a1ca1873b969b52237ef79ed36a9c9d8323a687"
    sha256 cellar: :any,                 arm64_ventura:  "619cfba979bcffed99a626d44312191913df8abade436e50cc762dc3c736a318"
    sha256 cellar: :any,                 arm64_monterey: "0c8250bfd75d1d3a85591870ee57972e125a626b7cd8f6cbe372880e8ffb17cd"
    sha256                               sonoma:         "c190a56a75c818548fddb50b748dcbcabf9dc414d9fd0252658134a42b63297b"
    sha256                               ventura:        "fd8c7e1dbe194e6ab3b56a5b9edfccee0a5a88ceee921ad64c989ce5aab9054e"
    sha256                               monterey:       "59671c2fd3afc4f6221fc275120618750b6f9f451a29f04185f67738b6717cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826bf8171152aef2ad7fac78809847e39ce71cbf024b06a1ecb99a4ba5f1f6c4"
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
