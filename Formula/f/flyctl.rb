class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.46",
      revision: "723591727cb72c7a4cc5940d06586b1dd63d79e9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de069910cc9059aece5161c1f4b0b5e07874d3596d0b9202e212d50ac113663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7de069910cc9059aece5161c1f4b0b5e07874d3596d0b9202e212d50ac113663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de069910cc9059aece5161c1f4b0b5e07874d3596d0b9202e212d50ac113663"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cdc4b80bf228fa5cf69d709d06db6e80f7467215acbe1092a6b5ee6ee17ef44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33074ab24394f1fd3e4fd057f6da575e9e4a5fc1b06ddff1df5ddc0de1e722ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fcdfcec13724db0e80bff171eecd38195ae0aa75fdd4f78f9c6f085fa1a874"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "production")

    bin.install_symlink "flyctl" => "fly"

    %w[flyctl fly].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: no access token available. Please login with 'flyctl auth login'\n", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
