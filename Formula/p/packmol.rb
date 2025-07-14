class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.0.4.tar.gz"
  sha256 "ca2398a6f8f2a326f52cda8e45a8818ea430a1b195fd3801d017e1a18f38fde8"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8140c67147c22ecd0c3a1a93364ee03ae375f07f17322a34abd02043763e97e2"
    sha256 cellar: :any,                 arm64_sonoma:  "a35fc381a2271a08a4e0869ba03ece641e74d0733fb62e0cfd6f508f09b7b58a"
    sha256 cellar: :any,                 arm64_ventura: "70a8ebff8efed95b5d2026f8b1f3d1cff0c38b247534118e5eab0121dfbb4316"
    sha256 cellar: :any,                 sonoma:        "e3342c27107982ce9f587eda7330c7f3dcce0d6636b230f190e46e591a51f395"
    sha256 cellar: :any,                 ventura:       "b2e2a133472be6e21801d2736e74cbdd8d3ea6ff4d508035f94dd22a71cdd59e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6491fe9440662b40936316d2616b991c95e9af842a40c98740279a94c8120931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "554849bca20498ebf6a37ad74b29ccd0cced6dd7959ab0cd2c1df2047bd9bf0c"
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
