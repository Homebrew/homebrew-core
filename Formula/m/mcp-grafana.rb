class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e1805f259168215aaebf2edab600ff2b24ac94e6190fc5d164b680f3627ede24"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb4ee9451852bfd86eb2fe4bd700f7c4d863fecd0c485eeff810b81fb87f0705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a0aca055340e71f7f2ae1afb77f5e6fd890db013de51ce46240e19892de0315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93a7bdee9028fdaaf9ac8a69055aefad6c78ce4cef2d176860b1c8a5922b9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "3daeb7a883da6d01d3eee08a49fbffb0902d9459ea65298e3c414d42fbb06191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde8e4df87dadfd3030f6e1a7030bff0f5d11ad9815ed37de89e5d63837fe8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc4a69a7a5ad5a228917b83bd512bdc082e90183160f2cf8b5ec36245f97c47"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
