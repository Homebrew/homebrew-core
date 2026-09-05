class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.99",
      revision: "ab8d26dbd44a4052012c31f9f7e71b6e4fa1a7bb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685198dd428ffa5bd5463e6552f88d03bfef777edbd3fc2e9f0ddf6035ce81ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685198dd428ffa5bd5463e6552f88d03bfef777edbd3fc2e9f0ddf6035ce81ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "685198dd428ffa5bd5463e6552f88d03bfef777edbd3fc2e9f0ddf6035ce81ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f2f0b5cff8e9d41ddb4fac9b4c18e044fc3100ee794b41120dc5bccf2f23942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43bbe1538650be7280f370e2f81ba53b27a49f65a71c9f729ab9c42e4845b51"
  end

  depends_on "go" => :build

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
