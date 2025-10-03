class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.191",
      revision: "54468f932f1a5750e33be235b37d1dfaa66cf5e2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7e57edc6fc548d2f75f14f0f2a115503e2306c0d78ed870573c62ae36e1f52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7e57edc6fc548d2f75f14f0f2a115503e2306c0d78ed870573c62ae36e1f52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7e57edc6fc548d2f75f14f0f2a115503e2306c0d78ed870573c62ae36e1f52"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8851ec982180833fbd5e4cb4fb11845339a6332ca2307ba13190be7c8fcddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b09f2b4067c6a24838e802142783b2e7dc820d05770603f05ceb22450fa42df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e92c0e03095bbed3baa69ad34d681029d7c633cf03146b3722501e411a78e53"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
