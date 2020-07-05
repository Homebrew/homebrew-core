class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      :tag      => "v0.26.0",
      :revision => "09edc73cf177f5f1d00e54549b6fa491e0507b56"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c3132525ac506d872e8c1fd764d5c016932b5af2ab1bd0a600995204715b516" => :catalina
    sha256 "03fed80ff4372247ec1232333e428641e911de06cbc3ce8b0179182372f0d302" => :mojave
    sha256 "898cbce553086343f2e98a8edb3750a1f3a72582fec53cc19ec8386d5578252e" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8" => :build # required to compile .pb files

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", :using => :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    system "meson", *std_meson_args, "-Dgtest=false", "--buildtype", "release", "build/release"

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
