class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v20.15.3.tar.gz"
  sha256 "a7e63208251c9e404437e3c58c976afc2e747d545c6c42dcfbf0e3e29c2c3d14"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a7f6bd5bbfe68d3d801fcc1a3fe568687d5089435d92488e535b1d7c7e62490c"
    sha256 cellar: :any,                 arm64_sonoma:  "7e6229a519d7a58cab2500b22c5d6c89545f30eabad307d25778dcce9adac3c9"
    sha256 cellar: :any,                 arm64_ventura: "a39f2408e21350b577b4477627a6611302396ac5acee817ace201cefa958c771"
    sha256                               sonoma:        "3a62e09cf3c8241d6d8dff1c5dc250f05b781482aa1110ca000dbc1e54ffb4dd"
    sha256                               ventura:       "8cce4bbe8efc07540329d712264ae1831dfdc49573f9e7a1bcbbddf02ae72cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d29264f6910cd65156d0f324e5edbafeed8d6b6d90e2f2d15df49964cdf923"
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
