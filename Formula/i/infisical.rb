class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.14.tar.gz"
  sha256 "3b66184753ece91ed912d1bcbbddfc6ada153290927d76b0e5c6b17963501335"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb84f2e54f3130a642d9ec009d0fa177cbe179fa858af87abf888c3d759c16fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb84f2e54f3130a642d9ec009d0fa177cbe179fa858af87abf888c3d759c16fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb84f2e54f3130a642d9ec009d0fa177cbe179fa858af87abf888c3d759c16fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "202aefcc2d1204a57f1bebe105ef8eff05b9dc0bb1155e6e9d4e78db0927103e"
    sha256 cellar: :any,                 x86_64_linux:      "1bb76cf8c7d393b8a59b98bd554853238d78d9ee6ece53d2d79b2d582c88ee0d"
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
