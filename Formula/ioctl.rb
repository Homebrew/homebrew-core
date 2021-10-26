class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.0.tar.gz"
  sha256 "dd6a8ba4c99c3bd43b2a895be01093b77aabe11c387fe2fb19fcd65a0a1149dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "729a69f059587797efde932833f358d3dfd6fa9df019d5c2d701cf0c51fbda27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d4cf8be3e079a14eb2d52828d3f1aec5ff1829459a88853129baff7f37eef5"
    sha256 cellar: :any_skip_relocation, monterey:       "cd44935fdea7f0747648e2363a8799ec94d0ccb8ab4674bf544cf906af8518e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "453336d2d6c20f8d74743482891bd3acb6e171ba33bcd7037f4ffd6c1e4f7678"
    sha256 cellar: :any_skip_relocation, catalina:       "a90584206c438b93886642314f27731f25a1ec338c7b6ca944314c5b3ffb24c9"
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
