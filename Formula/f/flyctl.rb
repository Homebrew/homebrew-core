class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.14",
      revision: "a05c794575d1c88084c240ee0224a0b14f5287ef"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a6f4f16250ca254bf1aef2e3d856cd7218cef39fbe22cd72aef9fe53fd79719"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a6f4f16250ca254bf1aef2e3d856cd7218cef39fbe22cd72aef9fe53fd79719"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a6f4f16250ca254bf1aef2e3d856cd7218cef39fbe22cd72aef9fe53fd79719"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca3e8b93fe8a362955cd048ed0dc62b4b6e26646220e4084fea2bc862795f76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "969aa4ab76c19b1c178ed327ddcdfd7516b0156da052e35f407eeadcedb1a19b"
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
