class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.45.4.tar.gz"
  sha256 "23f1e695446be3c1e646d53d838bc75d631df33ce123d034748a78fd07f10a70"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca348169a3d1e5406da7e5dffd930dc961cf85e792b30bebb02ce789e0a89b15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54d4336ff4c0df97531da59886787e569897b7393a00519d4086c114d347481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdca90a12c33eeb72baa313caf58b03b852c990412e89290febf265bf3d1d9f3"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cc8ec4935303c28ef2d46163ec52127da5e31897b636552711fbb9a0666a30"
    sha256 cellar: :any_skip_relocation, monterey:       "b000409e4f43909912df57f9d45fcc8551f07be1add6fb3b38d3793eb9a33c9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d042ecb9a361ec3e79fbe9abd841bfbc684618f00100f029e0c71fcbf476ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938981ff2156c366b16f834bc7e71ee9ef54999f8de90edc0874a78b0cf58aae"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
