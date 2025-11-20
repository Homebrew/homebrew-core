class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.31.4.tar.gz"
  sha256 "a89a9a44f1a4a5656e3a8d40911bb75982b96481fd20f10e9caf752ac6173cce"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6eeefb8f3b1365b4d2044ea0e059e55dab14a64ee7d384e93d130103c47772a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eeefb8f3b1365b4d2044ea0e059e55dab14a64ee7d384e93d130103c47772a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eeefb8f3b1365b4d2044ea0e059e55dab14a64ee7d384e93d130103c47772a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "77de17fa7f1111e37c91a8ed1af37e46b6cbc7d54d3759179b866bd98cd93ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe4754a1be41c8dee9651fc5912b1e5d2aa3456ee1a2f3862f3a26d63185375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4755376d50312080e0f5ec3d1b181edf3a7671e9daf0d0c963dd1831e2d0ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"mcphost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcphost --version")
    assert_match "Authentication Status", shell_output("#{bin}/mcphost auth status")
    assert_match "EVENT  MATCHER  COMMAND  TIMEOUT", shell_output("#{bin}/mcphost hooks list")
  end
end
