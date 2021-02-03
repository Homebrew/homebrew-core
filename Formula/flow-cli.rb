class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.13.3.tar.gz"
  sha256 "f57e327bb695599f2721c3780a82e63b0f5e4bd0f42b1de92051de3c9d3fe39f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea3ce256c712f8c66c397992e28f8e554bfe2b3ffff5e9ff61f080b6de30338b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ba30f55712ec634bbfca1e6632fde40695ce67341cbbe77a4c5d3064648c3d7"
    sha256 cellar: :any_skip_relocation, catalina:      "991af7e02bc9c0c536925e86c806689fee2f8b07c5fb68f8ce83d30b6e9c2355"
    sha256 cellar: :any_skip_relocation, mojave:        "86012fff7b601a09da729c8788e666e5a16d7da58ffd46baa8aeca0cf6d8a7d8"
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
