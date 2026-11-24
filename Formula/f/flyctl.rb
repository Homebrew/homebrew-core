class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.17",
      revision: "b4665b36fa5e9772a59fe0bb2e9ec367a07c50eb"
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
    manifest_sha256 "4d5567b28f051e2930031e397c0b6b194561dc4b0838d9e82003b4292fdd571c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f62d3a51cabd5f82469caab933c7c49e8eb1917241fc21f52870c67ebc8e7482"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f62d3a51cabd5f82469caab933c7c49e8eb1917241fc21f52870c67ebc8e7482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f62d3a51cabd5f82469caab933c7c49e8eb1917241fc21f52870c67ebc8e7482"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27d4239903ee6f23e7ea516a42c312ed715e15b97531ba46fe34b15a850e9ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b695bc6b51f05f2a578fd64a82aeed2cfdc9e55b3238b371204752d8d191c177"
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
