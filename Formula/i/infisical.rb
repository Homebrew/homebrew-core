class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.12.tar.gz"
  sha256 "510a7c65e79c115515cdb647add1e148c1d7e9f5d7bfc66c50d258f8d0acb1e3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42270ac14646ebccee031d8774b1ad9518fa86802e4e70561eee0f3175685caf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42270ac14646ebccee031d8774b1ad9518fa86802e4e70561eee0f3175685caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42270ac14646ebccee031d8774b1ad9518fa86802e4e70561eee0f3175685caf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6aef45fbca64f6ca0b5990fbf4aa94041b240ef90ccb37961e312391b82e1e37"
    sha256 cellar: :any,                 x86_64_linux:      "a71310592186fde2182719f6e7c63d80623824f770aaee5ae368ca16f2e43b2a"
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
