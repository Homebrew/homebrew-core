class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      :tag      => "v0.25.1",
      :revision => "69105b4eb0a3cf4fbc76960d18d519a0bdd19838"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build

  resource "network" do
    url "https://training.lczero.org/get_network?sha=00af53b081e80147172e6f281c01daf5ca19ada173321438914c730370aa4267", :using => :nounzip
    sha256 "12df03a12919e6392f3efbe6f461fc0ff5451b4105f755503da151adc7ab6d67"
  end

  def install
    system "meson", *std_meson_args, "--buildtype", "release", "build/release"

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
