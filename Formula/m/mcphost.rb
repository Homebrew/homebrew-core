class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "997e8b2fe3f5adb7f6b051c66166df8ffa1c6dba5de46fcc4e0975ed934ad743"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baf5ddfa871a62fd5f7ea71379bc38387be696ac3be30f2ff1f0c18ee69242ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baf5ddfa871a62fd5f7ea71379bc38387be696ac3be30f2ff1f0c18ee69242ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf5ddfa871a62fd5f7ea71379bc38387be696ac3be30f2ff1f0c18ee69242ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b96d49d859e020cc22e32a70d313ccb97f2ef0d3bedc880beaee723d7fb0267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a0e3a53b7538f3d6a2c703033969dfea3af837378af1b6ffe6c6d6eab74c5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ff47f19f95d5594b56ceee0dfd7aca5295d5301503d9fd8caf8d98ba845fd5"
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
