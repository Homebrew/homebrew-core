class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "2125149f4c52bea70e161cfa7d62a54430fa2ad07d8a67d9d3a64e6586b7624f"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e8375b06d7398149ebf69bd9e098137689098b0e751426d01c06aaff8ebf91c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8375b06d7398149ebf69bd9e098137689098b0e751426d01c06aaff8ebf91c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8375b06d7398149ebf69bd9e098137689098b0e751426d01c06aaff8ebf91c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c920f65313da82666181684a7ff0d97a6735f8918c2b5b8bcb0968433f83a15c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b652f039bbabc5ec0295bd88d7c21cc20ec6481196f11c226df73ecc6b87741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf04b5421b2c3406d44700ff10536526dc339695d7318db31a1c1fbde32d6f33"
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
