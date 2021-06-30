class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.25.1.tar.gz"
  sha256 "7b6b815e076903c2b41f08d5ad29dbaeeb5c773da739f501f8e0669ebc3583f0"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0a02380be3060e8dc95e5149142fb7d2f0a1ef9f4346103f714bbe0b0ad8530"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d58b7e17946067744b0f08d1f01f9bbaeb201d1bdd1a86489d69718a089a744"
    sha256 cellar: :any_skip_relocation, catalina:      "e486c64a8adb9f372c2bdac60a162568149dfac82148026b1b6cb53887ca0f86"
    sha256 cellar: :any_skip_relocation, mojave:        "712a7ac4b46cabcd198304e5a04da4e78b075b3b34f55e1047e30648d18cbf5b"
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
