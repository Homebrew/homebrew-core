class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.2.tar.gz"
  sha256 "9b011bb78297e7d9e98df884dfd132b1f1e9f35871105a86d5b666c1a2d28089"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "379909ab635df74e7023c695cc086dde8e6f3829f4723c90384bdf297077f654"
    sha256 cellar: :any_skip_relocation, big_sur:       "957f708c284a0bd8e656e65d4731d4212989ba48f17f990b570380a558f3cbf3"
    sha256 cellar: :any_skip_relocation, catalina:      "ec12f0dc2ead6a2d6bbcb3a1212c37218a1db3675d4f505e7af69a0e718e7dce"
    sha256 cellar: :any_skip_relocation, mojave:        "a12426fd332f4fa48f0728ae7604f26b361e3233f2443afc6dd25e7bc57ca4a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5c4e45fc2d032c17dc2f5fbde213f2f6c1188139730ebb9b918905dcee9b26"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
