class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.33.4.tar.gz"
  sha256 "21ce87aebbb5743d2cb8383910b36c8f4540b3363aefcf4217fd394a6642f06e"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e37752e6776cbb07d19975d8faca649d528af23189c71e6fe06a2d545f8cb9e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e37752e6776cbb07d19975d8faca649d528af23189c71e6fe06a2d545f8cb9e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e37752e6776cbb07d19975d8faca649d528af23189c71e6fe06a2d545f8cb9e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "06814aaf446d610d98b6bf4e052fa9f359e012540f3ad2661174562a7abba30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe363b69b95e99022b30e856aa74e021f77751852aeb4cadeeb69c3e88305a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6937beec4bcc659cc72f7c7a6eeb491d423cb2d4ae1c2b595399c7da0ccc92"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
