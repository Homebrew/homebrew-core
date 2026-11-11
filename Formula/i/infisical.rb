class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.6.tar.gz"
  sha256 "b32544794942112ad1e65fb16c00c700220a14b3ee69445c03a8020ff403bcee"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "826e7dee71d4787e82c2af710b6caf3d3c72350d238538e0b63b4ccc3d8708ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "826e7dee71d4787e82c2af710b6caf3d3c72350d238538e0b63b4ccc3d8708ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "826e7dee71d4787e82c2af710b6caf3d3c72350d238538e0b63b4ccc3d8708ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "707e2e081a5d8ad8ad56781bbba621f8fc313f549d73b63acac8e4bd6ce73de0"
    sha256 cellar: :any,                 x86_64_linux:      "23d4a42f611b186b2a5c7cb58f3fc1b56ce6e114741f1150c22958d7f54c97ee"
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
