class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "797fba127a4b9e85829d95176f23109506b87adaf1e7b04c0c9845b3a0631554"
  license "Apache-2.0"
  head "https://github.com/iotexproject/iotex-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030fbe31b9e2166af259082211aa261e83d076f6a51da3dc6547be0375834d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674e273961cc8f3590c9fd5dcbd45806fc9c259cbc7033f86dc95ad00fa1d412"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e808d19939fb4cd954e53d813bf1c92ff93459eec7860dc943a70d4808cfa468"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc41a5f7a13c5a52b6b3ad3fd88169a2f2ba00889ca807c10a12e7d90058b276"
    sha256 cellar: :any_skip_relocation, ventura:       "8695571a76082a146a2f966e089d6d495eb35b95832ff0eedd872515d00f2d6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4a09ecf29ad86975fa9a292d14fdc97792dac67558e3406f4c46a355368c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d580fcb4495ddcaf8e6a0c25cadd870f02bf50d20f3b473f7715cc0951ddcc4c"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
