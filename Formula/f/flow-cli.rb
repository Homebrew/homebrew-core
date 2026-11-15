class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "6dc750c4ff4230b66220d136309b6820af17d45468c28f3adc14f9eefc536583"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1dbc7fe2352a20f53fde05e0cb87ff4392a4b27ea1152b1d7b98688d85f3f5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "053a0f42a8ee6a75e4b3a39a0e517161b8ba471a708d3d603d1004933f026642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80a65e3a7a70adc31e4cc6c4966a92b5c9c18045a322e24cdc265ec75bc27c36"
    sha256 cellar: :any,                 arm64_linux:       "efb47bcf80a176f0dd2d616769d5f4302f7635597d9f55de16b31610c2db1027"
    sha256 cellar: :any,                 x86_64_linux:      "5dae877551f9641108e8b96d553a9d8b2a43df4689688848a7ac4de6e32b2d19"
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
