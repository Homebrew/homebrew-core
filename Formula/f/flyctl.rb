class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.16",
      revision: "fd050512152def8fc78ee1cc01ca9b0d374ee15e"
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
    manifest_sha256 "ebafbdf173ae97c7e03e44ca070c11495e8fdc46b42d1dfc9991ebbcfcba5dba"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fb0babbec181a98299dde9c44c3e817be5d8b3663a1eea27737abe2bc13638e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fb0babbec181a98299dde9c44c3e817be5d8b3663a1eea27737abe2bc13638e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fb0babbec181a98299dde9c44c3e817be5d8b3663a1eea27737abe2bc13638e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "202c7503a7d43862a3a2d821f821802a69d4f7753e5ae1c13de5339eb4a9ebf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e36a763a1598bb69ca96716bc0e14df06e81cc17184b050d3a21c4f399b1cfeb"
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
