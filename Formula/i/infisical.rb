class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.56.tar.gz"
  sha256 "21a497b1b9c2afd72b1960e51cf07848b1007c27f95a9e3ff7677b0527ed5ac3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "304dd8f616285b1d3d4da3bb5558bf4bd8dd29b1ce3e59fc22894a54ce8c8f8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "304dd8f616285b1d3d4da3bb5558bf4bd8dd29b1ce3e59fc22894a54ce8c8f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "304dd8f616285b1d3d4da3bb5558bf4bd8dd29b1ce3e59fc22894a54ce8c8f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "08689ee0f84d357e86b070e4b92bd2261da23bc085f0846a59b29fd31a6f362f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f230b76cc8a9fd44558b32720d8bc58e3388e74c9c898397c2e85cdee43a30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77fde642d52585660d943fcad1252ca7e706c79eebf68eed3d35c1f559877a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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
