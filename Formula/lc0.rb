class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.26.1",
      revision: "2520eb375d459c67e59edb11ca7be1726efef9c6"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e18677abb3104b8f2bcef3c7147059c2315700edccd0b2b12ff19dc655e37308" => :catalina
    sha256 "2be67e126032db242a59c913c575ab8458a13920ae8fd2bc75ffad27606e761a" => :mojave
    sha256 "75cfd0f372609c85dea1331cefa78a05e2d75cfe3f8c64456546e56480e4593d" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8" => :build # required to compile .pb files

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
    assert_match /^bestmove e2e4$/,
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1")
  end
end
