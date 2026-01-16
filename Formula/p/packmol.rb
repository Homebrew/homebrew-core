class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.2.0.tar.gz"
  sha256 "b842e3a3b5e98c6ccd2782c0bc5ae28f46134c2d1470056f153d44ade6e9cd6d"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a96743852ff12954acc74cd45865ba0806294928c40b4b9bb8e33e8491d95be3"
    sha256 cellar: :any,                 arm64_sequoia: "486069ee140a54494ae5307cea78c2c18fb67db695c63bab201741dbe6ba8108"
    sha256 cellar: :any,                 arm64_sonoma:  "4d389bddffd0d14cf143fbafb72460247f0305252a03bfa912db865273db40fd"
    sha256 cellar: :any,                 sonoma:        "0db1bd849ff8bfd7ba213853d88c8847e8fa039fc563bc3bce021d1b220d2dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d63528f167c14c38ef6beb7a612368caf96d8c6f680e0b1221b06e9f117fc17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f55a02c1887c26d76cfed3c24e12924a6c76ea6311d2e31bc1da32962db2df4"
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
