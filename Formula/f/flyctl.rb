class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.112",
      revision: "ca63052e2526df073e9a1a4ad57bcbe5892f0543"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0497d92476dd9fd50f40046eb8ea193f2a6ac7aee2a5251ecb018eeeaac322c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0497d92476dd9fd50f40046eb8ea193f2a6ac7aee2a5251ecb018eeeaac322c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0497d92476dd9fd50f40046eb8ea193f2a6ac7aee2a5251ecb018eeeaac322c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c4a97aebb57dfb8a54d271f63ac253c24946b94520bc93c036b02e55bf8e142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "527ff5ad903509230d88d239dedf3c0a499b739fcea23a4f563d41f2301b18ea"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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
