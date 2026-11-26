class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.19",
      revision: "4a98c6abedda3906ae7c6c772e581a787028d260"
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
    manifest_sha256 "cfb7619d32d6424da47db93b713af6c58eecf9ffa4152a3d7fce0a3a839145a9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7516593a28e798336e157d74824dfc0e7056beb3b44d3dd45fa7ada58ee4758"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7516593a28e798336e157d74824dfc0e7056beb3b44d3dd45fa7ada58ee4758"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7516593a28e798336e157d74824dfc0e7056beb3b44d3dd45fa7ada58ee4758"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbd06b51db737e479324891b88f68dc7f4fba230c9992cfe4f0877e862fbd51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9db67643974a3322ebb1a0bbcbe2a92075da8f44e12a4f585f0d0dda2a0f5b8e"
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
