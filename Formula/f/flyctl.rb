class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.12",
      revision: "23da327392fa656fa77433b18fc37bbbd164e88b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acdc4bf087036444b0033146265596ffe3cc151c01093cf2aa15c073e843a3e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acdc4bf087036444b0033146265596ffe3cc151c01093cf2aa15c073e843a3e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "acdc4bf087036444b0033146265596ffe3cc151c01093cf2aa15c073e843a3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e92e291c8ffe2b5b2783f41cc12e9fe8e08eb0777c1ab0627e38e9fc9ccb76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5de3d60556066aef949c367c261250277f2a011d864b41f21cda035f1a227e9b"
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
