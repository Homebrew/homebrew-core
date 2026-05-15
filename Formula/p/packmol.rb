class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.2.1.tar.gz"
  sha256 "6b8275be64e425fd578e7606ac22bb586108bc6b5c17d417873bd108928f830f"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66dca45d680f232725848fdc4694bf9dfadac085e552a7ed22dcfd427b809dd1"
    sha256 cellar: :any,                 arm64_sequoia: "63d5cdb33317d3c1ec2bfa0aca7f2bc9be7352b5bee5e8aba9210b97f21bee0f"
    sha256 cellar: :any,                 arm64_sonoma:  "1f3452eb657fdbdb80ad6c19a8ec5922a5f316512ca8dd50513d226206a597e5"
    sha256 cellar: :any,                 sonoma:        "fcd7991577fa4dcc089dcbbfa53349adaa64f6e85ddb22822f6efd41e2117b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b39134f576191a899dd10173b0df655bbc196ac76a2ad296fdc7225ecb40f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc65283514a3d88d3f4f28bf2b2749f2df38973fae0c82995570897d253574d"
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
