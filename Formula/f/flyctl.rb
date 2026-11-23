class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.15",
      revision: "bcead3a580e7b61e00b7046aa512558adbb94e9b"
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
    manifest_sha256 "d2fa6bc9586e21a4ff1044851d8165722f7917490b97a982b54cbcd54e793380"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c15511389051c763818fb0e7bd451a77f0d78c0e25f95c9d43fb36369c9781bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c15511389051c763818fb0e7bd451a77f0d78c0e25f95c9d43fb36369c9781bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c15511389051c763818fb0e7bd451a77f0d78c0e25f95c9d43fb36369c9781bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae922f75f0c75f8417719365012fbc0af8bd181c02ead1d5fc21716d62cbf75f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "584dd6dd67c655c25496977ce27fde9539bef6c3a287e6255badf64502aa387b"
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
