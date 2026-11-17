class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.10.tar.gz"
  sha256 "f726bf4092b7213e1a7ced4d5e96cbb25d96de54b650aff86b12de2e813ba07b"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0fc3a31408180b2a5d45b26465973c179a1f574753e58fb4ad879ed752594c64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fc3a31408180b2a5d45b26465973c179a1f574753e58fb4ad879ed752594c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fc3a31408180b2a5d45b26465973c179a1f574753e58fb4ad879ed752594c64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82d5d1aefb90576f0d6b3a95eb0b407c15576154338822b0313a8a98c48dad8c"
    sha256 cellar: :any,                 x86_64_linux:      "207a34a01fa047cb087fd26e4b683d8c1533085203e5204a966ecd06ef9ff44c"
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
