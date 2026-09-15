class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.103",
      revision: "b2db6ef5c20c84d84af4fc77a13ddb39a714ff45"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e081000354c6d63839fffacd1b5b69d05e7e784f4579d8fda894526a67091b8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e081000354c6d63839fffacd1b5b69d05e7e784f4579d8fda894526a67091b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e081000354c6d63839fffacd1b5b69d05e7e784f4579d8fda894526a67091b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3c3a84f0ba61d664a4565e0e3ed543d87c24bceece0d18deec37f2cb8249332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c45ad549942a8a5854d980cd1ee28f2c3d96f286843d43ee9f5a6ef0e23be8e3"
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
