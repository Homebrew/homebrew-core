class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.14.0.tar.gz"
  sha256 "2a7bafea4450c27c4573a0c3b35bace9f66d80a76af68b309ebdc93f553f7789"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7bb4dd2cbc82c5923c40c114dcdc6a5ac102bb2430a6b78e44ac763ac368ba33"
    sha256 cellar: :any_skip_relocation, big_sur:       "715af8536626e772b6821f9d5ddcc79f4cd38832b51e05c65c4776c1a14a2726"
    sha256 cellar: :any_skip_relocation, catalina:      "9814167aa3c6df83bbe7029d4ae58a69d8b02b887187886730be58739346d0de"
    sha256 cellar: :any_skip_relocation, mojave:        "6fd37b3b61703a76f33ad98cc53d337905c359fe750503ae3637701db0a49ba6"
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
