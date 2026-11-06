class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "a23d3e534ba25fa834862beedc93b258534f8c06ec2511b2d9f2f744d8266b21"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba9814692ce78daa59424370bced2159bc0c2deaa06fd610d2f04c747f20a329"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba9814692ce78daa59424370bced2159bc0c2deaa06fd610d2f04c747f20a329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba9814692ce78daa59424370bced2159bc0c2deaa06fd610d2f04c747f20a329"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27a48735212bfdfd5b3ad70088ee1c7e6161618ea0dddd5e2e94e416403860f0"
    sha256 cellar: :any,                 x86_64_linux:      "c9a3abc424bd51270dfd98233e67eedbab9ff2d7fe5f50d1c5ae70669066bdd4"
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
