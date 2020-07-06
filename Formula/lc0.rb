class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      :tag      => "v0.26.0",
      :revision => "09edc73cf177f5f1d00e54549b6fa491e0507b56"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a7f05f31e36d930350972f612b624dd93e39d74d901d85e279475245a91a44c5" => :catalina
    sha256 "c20fb7e7d5121393369e519083558bdf5aaf57f30fdb7bf6af7d28dd30a9050d" => :mojave
    sha256 "950c7577abdbcf4d1b4642b3e67abb3ee86c712b60518d5fc9760925b1a43bf3" => :high_sierra
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
