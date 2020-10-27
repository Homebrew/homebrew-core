class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.26.2",
      revision: "5869d48b5aa4d3ba2b26ebb00578d8dadcd3c5db"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1cba1d650e0933b19fc8ef6f866af1d988dede7ecbd1c3d2cf97e2bb4b3db41" => :catalina
    sha256 "bb4ae26a8b02c935e3f3e33e864223ea4d2b907df76ba3fbf07bc1f3b6b60fbd" => :mojave
    sha256 "a3a61d73914a71d5633b08c9a10591d2bf2e4896fcfbd463fe21fa8a97d4f445" => :high_sierra
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
