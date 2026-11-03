class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.13.tar.gz"
  sha256 "072b6cc0a7ad8b099c24f45766af0908026f27c3fc86f82af298a319811d2ef0"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7f1199dea5fc0a4175dd457507baae805ad7e818c23b17bcce5980be66fd627c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f1199dea5fc0a4175dd457507baae805ad7e818c23b17bcce5980be66fd627c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f1199dea5fc0a4175dd457507baae805ad7e818c23b17bcce5980be66fd627c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "150408f38f9c50aad68e557d6281e73439e024d89f0fafcbf0adb8089f96e9a3"
    sha256 cellar: :any,                 x86_64_linux:      "6a64426b860cd81643de7f1ffda8dbba6ef87c1b5a0cee4fc5bc8261937aa2c9"
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
