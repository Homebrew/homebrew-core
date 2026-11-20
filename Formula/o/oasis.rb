class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://github.com/oasisprotocol/cli/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "6d2fe798de3d71a7c8f7daf678580bb6979ddaa0a24b15b25d43d8792ba4b779"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54143399b501e9e4ed146259e67a1fb5c95493700f6165fac3fe2bbc67b1d0e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c21715c334f9629dc3d4a3f56aaa9725af6adef67ba4bb75096ae661709c3b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88a382bfe3261aeb279c8001e31a39b17d812a5dc7b545911acab02e2c3385d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3e1008316cecdfc2e0d268a978c86f0243b7ccd8ef048acbcb49d355243c9afa"
    sha256 cellar: :any,                 x86_64_linux:      "8b734f156cb467bce3ad5be50b793545fe8b84957f09a424fe6f90d58ffe1bb2"
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
