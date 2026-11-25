class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.18",
      revision: "e9880262304cf639c1e9221017f4043da9635488"
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
    manifest_sha256 "e1998b46418eb2dcbb8cc64bfd2ffa6b23952d3c3f1cc5e128c42c98ee15c804"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b8529c3f415e5e43fa41a859c83e9f31f393aed874ce4297c2223ef4a489e92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b8529c3f415e5e43fa41a859c83e9f31f393aed874ce4297c2223ef4a489e92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b8529c3f415e5e43fa41a859c83e9f31f393aed874ce4297c2223ef4a489e92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "039cdc67a7db9207068975f08fc0af1ece119c75b4c7a7d9db7c8c4f3413ab79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "70f0dcc3716f04f7217551e8725f3ee43145e9545c977768aa65dd88642a8b4c"
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
