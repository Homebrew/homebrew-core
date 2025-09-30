class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "a216061ca6296d28fc54ac70d50e03919bcdde3e8f0f4731b9e8321decea3898"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd1edb64358c4877f88bd2b0323c2377f722d7a52b6575908efdfc1ee9350664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd1edb64358c4877f88bd2b0323c2377f722d7a52b6575908efdfc1ee9350664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd1edb64358c4877f88bd2b0323c2377f722d7a52b6575908efdfc1ee9350664"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffdfd765bbfee2fb207bad902f276feccc9c066a1782ab5bddc87bcddc3ed3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98926ef89a1087cf2c1cf735e5f6a8aee42fb0fcc29767909dbee93963035be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfacbecbeccfcdf5fe7c2204f9fc027f9d7675d375f82c4dfa7a18dc532cf59"
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
