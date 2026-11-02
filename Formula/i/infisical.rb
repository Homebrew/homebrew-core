class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.12.tar.gz"
  sha256 "edfb908f0335eccfe8ccac7444eec713b0ad86cbf971028204464a778fd83a01"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f305b2ee7c16f392d08c96285ac5154abba674c537a2b537060e868cb946c39a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f305b2ee7c16f392d08c96285ac5154abba674c537a2b537060e868cb946c39a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f305b2ee7c16f392d08c96285ac5154abba674c537a2b537060e868cb946c39a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "996bc5746b3a1d9f6211e4bdfab1499cfe0b6e6ac956df99fb3e4165dc447a19"
    sha256 cellar: :any,                 x86_64_linux:      "971737baa90d957e858387c75f2ba9b883c115cfc29afdb87fa5787fb21a96f6"
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
