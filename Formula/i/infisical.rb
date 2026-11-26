class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.45.15.tar.gz"
  sha256 "f77980fd84ac7edf03b45dcd7ce7a67446cecc0992c6f8e57361addd9158a3e3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    manifest_sha256 "4f00c942ca084f14acbbdc6feaa873de21bb76e1ea7629f20054b0d599cf962d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bd3b0276998a28bd7633781fd48d348dc56b9870e3b85754d34a79e01362892"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bd3b0276998a28bd7633781fd48d348dc56b9870e3b85754d34a79e01362892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bd3b0276998a28bd7633781fd48d348dc56b9870e3b85754d34a79e01362892"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "664369b5956e0f9ead1b1a89d94ba5dc30da9bfdc85bd7799aaf2d328dacfb5c"
    sha256 cellar: :any,                 x86_64_linux:      "71530d96dfd9e7c2824083b76d26c4a364678b80d7a27aceb63b3c29a05722a0"
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
