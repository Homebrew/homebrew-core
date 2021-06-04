class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.27.0",
      revision: "6bb93fbd1ac94b8e64943e520630c2f1db9d7813"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9dc041c748fee70f187c04373ca80ba8c274d1b4b9a38ee135e6b4d6ce419fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "0966b60547f4f559ed7bd03cdd0bbe41abfed8e8a69b8553eb790e120aac0e24"
    sha256 cellar: :any_skip_relocation, catalina:      "ca05132c5b944255ce14f18960a59fa657d3dae1b9c088ff526b8763af793efc"
    sha256 cellar: :any_skip_relocation, mojave:        "7578de28c6a91e884166aa033e4682a3d4992390c85fd74c811acb584b1b3f45"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build # required to compile .pb files
  depends_on "eigen"

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", using: :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    system "meson", *std_meson_args, "-Dgtest=false", "build/release"

    cd "build/release" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec/"lc0"
    libexec.install resource("network")
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
  end
end
