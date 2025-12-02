class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.227",
      revision: "9ffd614b0ffd7e9c4bfb3b62845fe430eb33174b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edda736a55bd1fd7e0d5e497e68f9f789a86aa38a820ae60e43d658164daf86d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edda736a55bd1fd7e0d5e497e68f9f789a86aa38a820ae60e43d658164daf86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edda736a55bd1fd7e0d5e497e68f9f789a86aa38a820ae60e43d658164daf86d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bf656c48ec70430dd927a40be119e67d5ed4052b3c313b917f015c38c214bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aeddf8aa590656058a366c6acc9101926afbd7801e5a43d6c6386f6ae1eee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a39325db09a2e9e0d99a8e7972b5115525b150e3e1bcf882b4022d047d6b053"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
