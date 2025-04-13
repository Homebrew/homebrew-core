class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.0.1.tar.gz"
  sha256 "554a8a88348ad82b46e6195ff7c7698356b4a5a815c4f1c8615ef1b0651a5b9e"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b0641c064fc6d174e23ad1433132c05b311ad2d7a1475fa579e17f3834e3a7a"
    sha256 cellar: :any,                 arm64_sonoma:  "ee5df83457537a0d44f8162ad900f86e0e18315f53ba4b6088ab25d6d7f599f1"
    sha256 cellar: :any,                 arm64_ventura: "472868d489b997ec8575cdf57e6aeb37a0a4345a477c791006c28eb5988ff757"
    sha256 cellar: :any,                 sonoma:        "5aba746b30fcb9eadbd420d38b09e53f110bb20d432202218e26179e0bfff166"
    sha256 cellar: :any,                 ventura:       "3eb9fadee74075806473da5f09dea1818d2cfedc02a5724dfc0d76269d1d43b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf532a78652a05fd8d6a319738ddd5d76aab84df7f344d881e4c6b0aeafe3b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855f3fc3112ab28a9ad69f7064b874e75e5a23deea3e4cdd7e73e60315d817af"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  # support cmake 4.0, upstream pr ref, https://github.com/m3g/packmol/pull/94
  patch do
    url "https://github.com/m3g/packmol/commit/a1da16a7f3aeb2e004a963cf92bf9e57e94e4982.patch?full_index=1"
    sha256 "5e073f744559a3b47c1b78075b445e3dd0b4e89e3918f4cbf8e651c77b83d173"
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
