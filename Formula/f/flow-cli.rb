class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "d1b7f7e6fc0cd212f4d75310ba6cdeb25f85286abd99bccb3e7c8c25d775ae99"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c09a2aea34c79f6b194fd6049103bac3feb843d226603772812fd6a177e803c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "302c331cb4d08a0417f40e89d5d942c3d6822b0c9926e4751218a6c901dfa15d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedd8273bdaa4c73f502b39aa5497e62a955ea4e3dd299ea570b468fc57478b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "520551c0dc5107dcf1d5684fd121a9128e363451c646cac8216db1b0c8e7da72"
    sha256 cellar: :any_skip_relocation, ventura:        "599fd733aab89c5d4854e910ecb1d9dd16db38639f347716215665d7b5b87890"
    sha256 cellar: :any_skip_relocation, monterey:       "0ff3e6c1620d82d0cc24175bc4d1a80806e1d9080813678673cc520af711225c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442ab5627034b4a4dec8cebc032f744bf7af00cdcbd0a4220d87b3fa1ab6415a"
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
