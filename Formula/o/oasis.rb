class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ee608ff2b9979096bae2653fede1072f24b54b019bb5b5e1fe5865956847495a"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    manifest_sha256 "19de81203d4dca0644d5c3252a5071547d05a527bf632c984475134887c81cdd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "825982858e2859939c7a6f700d66d213ce6e8c000a623d6a8cf783516c437de5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18399ee1e5bd86d24d3e938631340097636cbd885c473b43d174f6f932f8a661"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "751baceea3e1ff3be45e0424eb537bfe81ac83d30a225c22a310f934f58ebb25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76ac38a8468be0a19043b144827c7b37efbf82a7a1ac75a40abf336949fbf3b8"
    sha256 cellar: :any,                 x86_64_linux:      "77bba5602bc609c2c765dd8d6c70e3237c31ab8ff6157744982745e67a8c3dcd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end
