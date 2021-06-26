class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0cf769e1700248120683f3dc731c489805494d11418e13b7a6c3f5362bb09507"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2267bd8006cc3a1cfb2bd089e653d786d4aacf7d6a7df62b6e24e1bd7b077593"
    sha256 cellar: :any_skip_relocation, big_sur:       "67dfe479f72d454eb9644e8480936f56b21c38cb99c1946856753950889a4af1"
    sha256 cellar: :any_skip_relocation, catalina:      "f5400c99cd7b1f29079a142d67ca0073a70e7016bffdee12357e8f2ec8b4bfd6"
    sha256 cellar: :any_skip_relocation, mojave:        "943124c877463a64925cad75a45b0dd591bf424741473cf37bfe7dcdd5f9c015"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end
