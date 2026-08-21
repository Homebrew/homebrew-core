class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.2.3.tar.gz"
  sha256 "b26af58d407b1c8d786aa6c2bb6bfa40d741aaa0424db51300fdd6fd66dd4813"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c02671b749efd890c2608698f114ec810a24ee91009ba69b53bb3ce6bb36ba9d"
    sha256 cellar: :any,                 arm64_sequoia: "d291198ee651cf540a1cd53850f712b270ada0d3ff4f8d2d11d28c82aac5cc7d"
    sha256 cellar: :any,                 arm64_sonoma:  "3c9546629911f4bd7314ccb598d91fe8e31350e439c278913f48a5e3e9a1fe01"
    sha256 cellar: :any,                 sonoma:        "081ef94789008bd380bd0b2257ff28f01135a4b89298da5ef0f2c1c65438f434"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab0ab010ac32a4dd77f31fb3967f05c819e808e05575979cb5f2c65fb0a4f1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cedd3c08ab2a8215cb18f527ef1c36c0466df83f58e85ee0d6ca34a9ca76b5f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
