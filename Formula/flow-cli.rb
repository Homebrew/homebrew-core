class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.31.0.tar.gz"
  sha256 "c13ed4750e6e2cce947ae9a79fee89f3a6d694259a9c8b81593ecbf1837ca27a"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b12bc75eb18e9f9a3b86228f20067d100582558c9dd7efb828c31176b8a340b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81026150836a8bc0479a2a4044b7a301ea9f111557182e1f8f0ab74f45d0a624"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1fbfacac940570c370f332ce6baeb5b6182441ecd8b08d12dae1bcfdd64a3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a38c2ef35e6b073e019b0e9bd0b4b48da6e040743cb0291f81ce7c5e413617f"
    sha256 cellar: :any_skip_relocation, catalina:       "32c33dd1b2c5e9093a88b486907182418f01c173d7096748b1893bc55a60b2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34553f7e2f35f8b48d78bbc7de790e4da8b510dd87c58f7adc19ba403de08f9b"
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
