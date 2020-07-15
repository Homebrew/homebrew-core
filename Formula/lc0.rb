class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"

  url "https://github.com/LeelaChessZero/lc0.git",
      :tag      => "v0.26.1",
      :revision => "2520eb375d459c67e59edb11ca7be1726efef9c6"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "468c173bd7435f97d516b9b4fb1817402a807de7f918a1683747b03fd8885d8c" => :catalina
    sha256 "c39b2e6a6c154e7a82c358faa46ff878ef6334e9e58638a550baef78a6fe0db1" => :mojave
    sha256 "7db068bc2f8104a9fa487e91ff06add704d2c491b1894a343fa6d8bc39a8b0e6" => :high_sierra
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
