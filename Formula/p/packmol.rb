class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.1.0.tar.gz"
  sha256 "bcb64849bd490c329018210cf91375871108004ac8bf3e8cf9463e42e551fe46"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39a5804df674e0ba5343fc09a4fc9cf258f19f4d417c082533329adc5ae8e3fb"
    sha256 cellar: :any,                 arm64_sequoia: "49b9c7b2d7757a9646cbded50378cf20949504ae5dbbaed8792be5271b848924"
    sha256 cellar: :any,                 arm64_sonoma:  "866657ca34b08c498c0dcf3a9de38ded338958917264edea2b8a7f8c95c394d9"
    sha256 cellar: :any,                 arm64_ventura: "1d737174c4898e515ed2faec71c803bf50063a9d114f400c6fcb974caa04897e"
    sha256 cellar: :any,                 sonoma:        "3323dcd875ee6979d9634eb5fd2535492fe1100795c4c2c2dc1c370e110809bc"
    sha256 cellar: :any,                 ventura:       "1b3d07ac1dec6a79321843acd234939b313c0a2e2c31ddab818a3b8a1f0af9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c7f6d7ab392a58035a2a30c16748726495484e90c88044e7aff02d158a7330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed6ebef0ef0f738356790fd1655a919a2b180861909338649dcfece32c2742f"
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
