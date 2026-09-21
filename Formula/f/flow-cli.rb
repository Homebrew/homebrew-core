class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "c3783a0a00fcc78e03f505fca5bf993bbbf6739d84308e4c0eeb17b013f899ac"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ff16bb34e82a4472c3fa482c4597b78dbf0429f606ffd5348309930b07fb81b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcace948ac000b96e1a896811bed9b9bb4f08aedec46bd1a8051410371d3e8ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d2115453e2ee52c99ee7b30d22cb4d6eb39d5c8bf3bbf32c4a1dcb0be82a7bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e0460312bc38530e03624ab44f9f046787f697e986f8a7060849a484de388b4d"
    sha256 cellar: :any_skip_relocation, sonoma:            "57cf2dc1730d6cb535318280a785e54fcd7bcd0beb0c0f550f4d480f0a9f06bb"
    sha256 cellar: :any,                 arm64_linux:       "76186f09c1910e520cdc2dfcb345280970499f8e04830db74cf8a04f952f0b3c"
    sha256 cellar: :any,                 x86_64_linux:      "5de16b0fa49523139ce367c55c4330702666f94b3c928dbaad54e79c0223dfda"
  end

  depends_on "go@1.26" => :build

  conflicts_with "flow", "flow-control", because: "both install `flow` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flow version")

    (testpath/"hello.cdc").write <<~CDC
      access(all) fun main() {
        log("Hello, world!")
      }
    CDC

    system bin/"flow", "cadence", "hello.cdc"
  end
end
