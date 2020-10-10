class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.26.3",
      revision: "e339467ca9db5af8abd8037764cf69d44367c351"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b90a04c475d27106b6374fbf38f364f2c3f572ed5b436e5b85d20ff6e2e682d" => :big_sur
    sha256 "6dc78714dcf633763a821ea0f83576e8d85020f9bad874394288c24cdcef9208" => :catalina
    sha256 "1aebbe4e8a4e4f447ca6ceddfdb8a92f70afaabb7043f40ee2c887fef1cd79c9" => :mojave
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
    assert_match /^bestmove e2e4$/,
      shell_output("lc0 benchmark --backend=blas --nodes=1 --num-positions=1")
  end
end
