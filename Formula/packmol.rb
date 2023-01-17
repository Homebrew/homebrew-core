class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.13.0.tar.gz"
  sha256 "79f0b0d8c4c0af20d8489f409e2209ef48294ca3e30d8d4e6c37db7127d1c805"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c48f1144df99ef46f2e4e4bf43c561662a23db5898fa0256093a03ae1595ed89"
    sha256 cellar: :any,                 arm64_monterey: "7bdd9c1fe3b95d8cbbf0898d012e55e80c8aafec987de59cea748383966d398b"
    sha256 cellar: :any,                 arm64_big_sur:  "ce285a9c245ead704bbd515091c8fa6bf0809d6390c8132bb5b0719c39106db0"
    sha256                               ventura:        "942ed122800a5c4e7b48f8bbe659fb54d5576e9ee225bf9a0fcb1fb1b361dffe"
    sha256                               monterey:       "2fb3817ed2a3a225afc40f653313f29f890be86cab22e42ec0bc1f364d5b3f50"
    sha256                               big_sur:        "01ddcc004354aeb1d2cc4e81233b90bccebb12062f71a9294d8706bc98a00516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8c0bdb81faadbe9a4badcd342ad5e34f22e8515e67d1a6bd34f75d1f0e1e4f5"
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
