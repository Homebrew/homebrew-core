class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.12.tar.gz"
  sha256 "edfb908f0335eccfe8ccac7444eec713b0ad86cbf971028204464a778fd83a01"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "164f8891038d01c1dcadb278fa36138b0616ea05684747bf06cd9af53478f729"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "164f8891038d01c1dcadb278fa36138b0616ea05684747bf06cd9af53478f729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "164f8891038d01c1dcadb278fa36138b0616ea05684747bf06cd9af53478f729"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1682c425b187c72a5d7cc1cc9e408f41998b250709948a696e0a0ba249e379be"
    sha256 cellar: :any,                 x86_64_linux:      "54ba3ea0cf53a2eef0803d0b2d5d8bcd223927e17af39d4dc0ec80b1633be943"
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
