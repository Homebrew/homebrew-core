class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.5.tar.gz"
  sha256 "16d22e7478a89c12fbd07a84b8c0ac72ebd46e229cbb2cd3b2888dd4220d17c3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a04ad5f074c669c48b1cc360ea2e4926822f3235d9dbc20483950b0ddd9f3410"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a04ad5f074c669c48b1cc360ea2e4926822f3235d9dbc20483950b0ddd9f3410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a04ad5f074c669c48b1cc360ea2e4926822f3235d9dbc20483950b0ddd9f3410"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "70e7dc8900c49cde6fc021d6d34fe0a87ede18e63bf0efe722b5a33eb2bd3b3e"
    sha256 cellar: :any,                 x86_64_linux:      "ed5025d1565425b5fd278a3bcd3883a77386690c56d55ac6b48498c95b7690b9"
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
