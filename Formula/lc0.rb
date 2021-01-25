class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https://lczero.org/"
  url "https://github.com/LeelaChessZero/lc0.git",
      tag:      "v0.26.3",
      revision: "e339467ca9db5af8abd8037764cf69d44367c351"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "84db032b8b20484b983551ef61f5bf2866a9903f7a9cacec5b12b77563c85d15" => :big_sur
    sha256 "90a5d1f252b13794d90a5c49f86487898b6f2e604dbb3a7d7668812df85847f8" => :arm64_big_sur
    sha256 "af7ab110193665adb07a14006319d5ccc8b3086ad4c388a029fd6787feb00302" => :catalina
    sha256 "19dd162b0f6fa4536bf21a873ac400d0b7fa188cefe731b7db1d93049039d6fe" => :mojave
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
