class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "72d3b7cb128c4eee732a299d85c518b48f7e8b8d4a8da875f80e99002f5488c9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b0f7e2a452f967576d93f1183bcb1a23036b7a74c08f3c4dd09e9863d0a1da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adcee7ecf1276c678fea4057cc045faa53f7361e522cd6f76f4d3735445673e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adcee7ecf1276c678fea4057cc045faa53f7361e522cd6f76f4d3735445673e0"
    sha256 cellar: :any_skip_relocation, ventura:        "03f165e1654e929f76d5bdc407a499a77ac6b1c780d7b7559203598bd7bc3697"
    sha256 cellar: :any_skip_relocation, monterey:       "b24e93a5aa10103088d799428b39de96e545e2596434b3fa56eafa144a6784c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b24e93a5aa10103088d799428b39de96e545e2596434b3fa56eafa144a6784c4"
    sha256 cellar: :any_skip_relocation, catalina:       "b24e93a5aa10103088d799428b39de96e545e2596434b3fa56eafa144a6784c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8e809f9cafcbe4465ee6d8364711e0a1c30e0793db2c50191fe4d57df0d7cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
