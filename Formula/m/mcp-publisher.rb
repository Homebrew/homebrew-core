class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "afd8ca335cdb05bfcb6b94a0bbc981a02ddee0bc392fbab3c2976ae04eb5d215"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c9e5b234f36a2f3aa6cd838fb11ef319e4fe32fb50a74a9b2e821f9bc1db85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c9e5b234f36a2f3aa6cd838fb11ef319e4fe32fb50a74a9b2e821f9bc1db85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c9e5b234f36a2f3aa6cd838fb11ef319e4fe32fb50a74a9b2e821f9bc1db85"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad5e18a0941a163b90ec41c759016177fd99ef4421cda092867c6578a3d15e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5103e475785bff1d39afaff1c001af6d01e001a18ea5439542559bdfba9589a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171fbf9c9b671a63cbe5b1819e038fd5d5e121d631f306a3e24fc4be293b5014"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
