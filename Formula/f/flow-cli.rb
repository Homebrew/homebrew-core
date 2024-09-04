class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5767f8e2a1ff8ec4fbd4b04ddcdc0509fcc9e7cb24cfc02d7ec87f847ed9c222"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fb55ca02eca7019f0ac0f856d714323a1beac0bb3ae08b3923224804760e7b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80c9bedad29fa9f4c4de27f80312a756941d9226593e7cf12e18f32af0f8afd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e341d9d44472f60a8495308b8407eeb6b023766cabb75371ab11942f3e5dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa5370622028455e24ada74ee8670d391bee21f056d0b24455db4ffb6d76b706"
    sha256 cellar: :any_skip_relocation, ventura:        "effe05a6c64b8d8aab2f81c043b0711632df0481ebb37ed2089a8c8df2a257e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfcbe1a1f94b0efeebec2c6f81fab469ea71978d0f456db9cde8f103768c6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eeef7dd7c70439463b5cb5f767c52676b502a8d82cd3e4bca019815ed92f9d5"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

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

    system bin/"flow", "cadence", "hello.cdc"
  end
end
