class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.1.1.tar.gz"
  sha256 "4bad785e6e1b91d8b80934eeebf91013e940c577693bbecd7ec56eb563f5d97f"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5b3df00f0d2a4f4bedf45af4907f90fb2b847fa5888e204604568f6a7895361"
    sha256 cellar: :any,                 arm64_sequoia: "48e8f1d8e37b3fc6a44c9a5c9c4b7976bb47166fa85f14e3771cc29a349f4f36"
    sha256 cellar: :any,                 arm64_sonoma:  "c737487817e8681c2effc46a2243f2098a22c7f3928c8ccc4603ce9a43bc98ec"
    sha256 cellar: :any,                 sonoma:        "e29361da29e7d240c2d12d6857197950fe861865a2f3ac03f2abdd28cd56a75a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ed3e203477a3f7e97beb8f84fc260b742d5879d6fb68e12ae571c087bf372aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a489ad1696ded2ee9b2bb5bba5de5a54a243d972f630e9f6a8a942cf7a99afc8"
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
