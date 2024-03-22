class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v20.14.3.tar.gz"
  sha256 "c70d8dff6f983adb854cf816df3d4a389b5cc724e70a2430b54793051eaaa4e9"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "139b70312b6d049cdcd10f4fb2e3061c670e61b79ac742f8e604f16e2ffe238c"
    sha256 cellar: :any,                 arm64_ventura:  "bf2434dd3dfeae8f3fc886779f2e89adb5b9a0d19b4b91ad20619a3ed4446ec8"
    sha256 cellar: :any,                 arm64_monterey: "79688abb1c5de90e70843360881bf6fd37c493e56794e13ac95480d58e9887f2"
    sha256                               sonoma:         "f952369d3969d66f3866c03fe02d0097bb02d1f812895c932ebe8407b0f439ba"
    sha256                               ventura:        "cc2b60a0241838aaa459e8686c9d7d619f9c37b8d286f8cd55251ac5417d3d21"
    sha256                               monterey:       "8688d27d805a9219a1b55f1900517b38540c22b906782466664956a9091f5403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c43605cd92c451af726f9fcb0bc58ea32f42de8acc87bbc55baf38b72fa1b4"
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
