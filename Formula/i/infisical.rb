class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.99.tar.gz"
  sha256 "ea59e6b700a345ed231593e2bd6a01f2fd3ccde7dd894633d37b2cacc9416264"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b675a28c8bc2f22073fe001e14240705788a4cfe6bbb31b45aeecbe5b2298c03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b675a28c8bc2f22073fe001e14240705788a4cfe6bbb31b45aeecbe5b2298c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b675a28c8bc2f22073fe001e14240705788a4cfe6bbb31b45aeecbe5b2298c03"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47630dd8a78b8266c6f28d0e20106e18dce7548e538d9ddd045768f6d1ee430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b5b1e2c65bf9f573cf22e878a955880bd8a8f60f13bd7312cf3487e90490de"
    sha256 cellar: :any,                 x86_64_linux:  "3f740f5d1855d8bcbbb0b55e11ab705b817ebbbbf94ce5f407ce71c58b962b6e"
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
