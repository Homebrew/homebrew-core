class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.114.tar.gz"
  sha256 "798eb3b1acb5f554638b458b11215535d4a165b48c77f8e7d06c4d1e5ba8674f"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "970a802a38196fe476eaccae6176aa61e607ad92cf2ffb728722930f5c0f5a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "970a802a38196fe476eaccae6176aa61e607ad92cf2ffb728722930f5c0f5a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970a802a38196fe476eaccae6176aa61e607ad92cf2ffb728722930f5c0f5a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee6900c86f8d443349ceed211dda5e6a2e721343e9384abff62ffd2e77c3e5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6a67b10dd5df19557241b071823b810dec011dbc4acc0073f7efc00d9d5d116"
    sha256 cellar: :any,                 x86_64_linux:  "b3a154ba8e631ebf56c7919ec17055b81541fb34af88775a01f92a4a1371f454"
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
