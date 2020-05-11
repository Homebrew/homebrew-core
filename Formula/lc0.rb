class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      :tag      => "v0.25.1",
      :revision => "69105b4eb0a3cf4fbc76960d18d519a0bdd19838"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "54ea227ae5e072cd33580ad6294ae9e5a1a8ee34bc8322f7d376ddff287e9633" => :catalina
    sha256 "ef181a97aed047dcf7e2dbb06415e74ef5ce7bf4ca4eb24e96f4a8c5fefb59e8" => :mojave
    sha256 "151e62a4290105fde099a552d27fae4328bcf65d6617c1e85be24162289c9c2e" => :high_sierra
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
