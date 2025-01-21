class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "bf07410819c60d371cb1177bdff29e353e5afacb94e8ea5393957f8c0bee6e37"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e221d7e098f0eb9b4ca34918a0a6b7999b613a86a3aa241874162407d0a5a16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc49d3c802a6325eb0aa2704ffb3b7dfdd3e32ff4c3304088f387185145865f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a6eb34197d0dd3c0e6b81c1123eba166787f02c6fa2af83bb15a64a67510932"
    sha256 cellar: :any_skip_relocation, sonoma:        "56c01de6ac245fea494ebcb34535ceabc46bfa8a297ff97064e1442497920a51"
    sha256 cellar: :any_skip_relocation, ventura:       "44464ca18e28bc8fd294598b9ec0c24a8223ee705d940cf993b8fee790013ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5803ba25e646cc70371cbb4cf816cd22fcec9061e3d029abc28582b64704a365"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
