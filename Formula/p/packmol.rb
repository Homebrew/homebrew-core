class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v20.14.4.tar.gz"
  sha256 "45ec33798d5f10c0aac6046675531a0e98567890c1a76f753450c5fc6b1aaa2f"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3b16a432f027c075f1fd7078db57b6feb1eada927947473146af4876094b9b2"
    sha256 cellar: :any,                 arm64_ventura:  "c1c3e091d3d7667c3983cfff7cde909e2099832bb4343fb0fbd5fb0a7a4baca6"
    sha256 cellar: :any,                 arm64_monterey: "c48c02e992d18b5ef28d6a1d4260c2c1664988f9292ee742511f338bb227fe16"
    sha256                               sonoma:         "fe83dca542e6972cd3e6ca69964f311a55a21b799e46ec1a9a840d1a4788fbfe"
    sha256                               ventura:        "388131107a818f2bf37273696aa423cec6d2bc899d812611b7912cbea74ec7ff"
    sha256                               monterey:       "19bc18bc68954cd1b02b2ba6e43e5f89689c7d5dd241423f2eb45db51c20fe0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d15ae2efa286fcc0c4769a9360423f99329610bd69b456bf089b1957dbdee2"
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
