class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "b959eb188361ac635ce8645864d5c9393ae3f708d42dbb44081c7916c77e935e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f2777a69bfa4e61864ae9d04422d32d3c44430c83b01e4b6bd4aad124222c36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f2777a69bfa4e61864ae9d04422d32d3c44430c83b01e4b6bd4aad124222c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f2777a69bfa4e61864ae9d04422d32d3c44430c83b01e4b6bd4aad124222c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e20763a817c0384e35fed67c9a817ef50e428f2225af5288e112e6d5e6bfb227"
    sha256 cellar: :any,                 x86_64_linux:      "51eb541fdac9d982cc3ffba128ce732fa71e28ffc6bda7d547a6d8cfd2ec9bdb"
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
