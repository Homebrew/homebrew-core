class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.0.2.tar.gz"
  sha256 "4b63d73400f7702347d9ff0cc4d0009be5a752afa7af00ad612554e8918f00fd"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff3dc31853b5ed73c4ed37e81f0e1fe05d0a8af80096c045622a9d6dce28dbda"
    sha256 cellar: :any,                 arm64_sonoma:  "aaa1f1d5d09a01d6ce4035e1ec5c4f3fa74f136241881464da849e28ce84f736"
    sha256 cellar: :any,                 arm64_ventura: "18317fd790c03ec39ad0c291f1b56fc94083d6ccfdce9d4f222c977777799daf"
    sha256 cellar: :any,                 sonoma:        "e348a69540b5961cd274a140e6c776c6b1be60284d616b4a55f1714a880b6d68"
    sha256 cellar: :any,                 ventura:       "6694cd43a3320660608ca071a6467924095f624ef3ec30cf9f6d1d6e6b00e239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eece5b9234339d41d38f1468f0c00222b8e30ce29548f8860fb509f184d013bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ab86f29d725aa61afcfcca95dd7a941cb606b6f36218765da30a7c7e260b65"
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
