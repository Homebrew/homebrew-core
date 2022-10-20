class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/20.010.tar.gz"
  sha256 "23285f2a9e2bef0e8253250d7eae2d4026a9535ddcc2b9b383f5ad45b19e123d"
  license "MIT"
  revision 3
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fecff45f74a420d0130da37bf0cf5a28af97374bf937d420224c0b788c9f3484"
    sha256 cellar: :any,                 arm64_big_sur:  "71e139ba5f9087ca1138850734c38b2deb8ab1796f31c9eac69995e614039360"
    sha256                               monterey:       "a542c7ba163c2c80ee6cff96d723d870365805857cc33850a5cb476a9d4fc7fa"
    sha256                               big_sur:        "f70726c2caa17229c95639622cc67cb6a7e8328b8159a1802bee7ad5ad6f486a"
    sha256                               catalina:       "d97c6f8b4ae3d70ddb8dd2a18f2ad16708a0d6b4e5cb98af4def6cd44b760e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eabbc1b2d945ee2c28a7df09863d4d36754e4d0f925c0b458931a89d245348c"
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
