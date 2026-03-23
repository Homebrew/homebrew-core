class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.26",
      revision: "c77732c080ebda76cdb539007353d2ac61977f34"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76ae546f768fea665ebcefa641ffeae24d512486b4cb4793923c71e42dc9d531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ae546f768fea665ebcefa641ffeae24d512486b4cb4793923c71e42dc9d531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ae546f768fea665ebcefa641ffeae24d512486b4cb4793923c71e42dc9d531"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed8368f9c25447f302c8ade5628e041db7a56480b9bf80b8d3a96ed4842ddd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efab86e63f63e217776e3aa0a8c32a4eae5661b47a710413548ce6fab7aeb0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b13fa2b63706f0d4ba30e8c8eb08b97c1f05cfbd89385bdacb6fc2ff913f3fc8"
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
