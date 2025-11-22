class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.1.3.tar.gz"
  sha256 "21a22e4e3f183e2c594c2e1d85cd7c16a95a8c609b36fc28d653f6c2c2d54c0c"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d169d53193bd7fd8181af3630d492371b56730dccbc8e5b5c014161730764ad8"
    sha256 cellar: :any,                 arm64_sequoia: "9fbbd997cc256bb7df7585e93a76a1448405c9643f0a000cc16f345099b9a950"
    sha256 cellar: :any,                 arm64_sonoma:  "6382ae01ce6928b436068f63d7b1bf9ea175e0ec9fff82a01ec782f3e9a308a2"
    sha256 cellar: :any,                 sonoma:        "10575dd06b032986ccf433958a4fcc71f3738d105e4fc21c06a0ce31713dd999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a19ab339cb0c10331695c705c5767a4988efc7627dbf31bde63f7c79bc5caa11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa7ffd494a2c57b28fede763370cc164d3a4f7a801c838ca0e24ebc8090f12c"
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
