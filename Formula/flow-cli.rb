class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.27.0.tar.gz"
  sha256 "0d3668c672b296b8a928ff30cb499e03ede72756a5ef50f7b2e2b802fe4d1543"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40b0e1a3a7a49441524de46d9dee1048fc3b91dbf71362d2df5f89d41af159cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "876906daaa3f1233b2eda6a3af164f752cc6a213788a86faeec2a0e6e8c432c2"
    sha256 cellar: :any_skip_relocation, catalina:      "8021ef83701a0b8db09606a8e6fd21aa2e9c00a584911c6409b2fad9eef922a0"
    sha256 cellar: :any_skip_relocation, mojave:        "83b794969b7e62940c515c50d980c2663284a8a4c2f61008c285a28b0736f76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1c710136eaccb60d5f55fe066b58eeab1e041e127bd6ddee528833c707217a"
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
