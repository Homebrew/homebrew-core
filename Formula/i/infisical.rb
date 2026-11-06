class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.3.tar.gz"
  sha256 "bcf84b4e7f08d554a2fbd6df02ade7b24a9ed20ad37af2158014d3e4847a7716"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a2d0a70378ce6a8eec26a55d889d9fa14d182226b5926b413af0634308a39b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a2d0a70378ce6a8eec26a55d889d9fa14d182226b5926b413af0634308a39b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a2d0a70378ce6a8eec26a55d889d9fa14d182226b5926b413af0634308a39b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f70e481272e6f30070df3e062b59b464ae0aeddb325f559d5523914453e4580"
    sha256 cellar: :any,                 x86_64_linux:      "2ad038217353e82aa229f5d0dc4eb84ef5f91e02973cd7ae2c08102e25358436"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
