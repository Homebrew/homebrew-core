class Mcphost < Formula
  desc "CLI host for LLMs to interact with tools via MCP"
  homepage "https://github.com/mark3labs/mcphost"
  url "https://github.com/mark3labs/mcphost/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e612b98931be1c708e6d0df23ce32261a6ffc584a2cc97b7d497e4978cd4f9a2"
  license "MIT"
  head "https://github.com/mark3labs/mcphost.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24c1b87c51b2b6a10ef00e1e35a7b2219608fc954808ffa467b5ae01cf10e8c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9023920e8eb7416432a30ddec51e54474e688eaf4eb89d9da91f997e8300630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9023920e8eb7416432a30ddec51e54474e688eaf4eb89d9da91f997e8300630"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9023920e8eb7416432a30ddec51e54474e688eaf4eb89d9da91f997e8300630"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a45eae900fae19fd5602270904693c4fc4f00c23b0bd03ed48e65e41b5648a2"
    sha256 cellar: :any_skip_relocation, ventura:       "8a45eae900fae19fd5602270904693c4fc4f00c23b0bd03ed48e65e41b5648a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e18f7439f1ee444de078228b9769ddee92c52069f29081200bf0c47a68baebd"
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
