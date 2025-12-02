class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.1.4.tar.gz"
  sha256 "62e0bf9a5d0671ff1f03d57671c8bb91fd16790fcc07f0e68f1829b1f34fae48"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e09ea01de1dd25a21f4b6dcde144bc30e27abc703432d561e97f2c56a61e4ffc"
    sha256 cellar: :any,                 arm64_sequoia: "bf58a1611c2329dd02ccb486c0ea27beb5dadb8b3dd0b0e74459ddaca0f976cd"
    sha256 cellar: :any,                 arm64_sonoma:  "9b3c6314fbc1c63d17856e6b443620850f26f0eb573661591c043d730b753f4b"
    sha256 cellar: :any,                 sonoma:        "8d0078d5e626a6468dba4ab5a3cf0e76e168972e250b77f1c5b186881c24b588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bc81fce99ef72fa922db22d78ee3495a3a796e33f7dc03b38d4795a29966a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f68a16c611156d55f30e6a96534cca8c6b54d9754f362c303cb0c2bcd0a84a"
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
