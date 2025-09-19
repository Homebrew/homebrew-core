class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.181",
      revision: "34b100271c5d332c491e89dfef8b8dff1cb8d1b3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "581b4f062871b671474e0db8f38ba74fa529cda853beae54de8db10f2fc16e98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "581b4f062871b671474e0db8f38ba74fa529cda853beae54de8db10f2fc16e98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581b4f062871b671474e0db8f38ba74fa529cda853beae54de8db10f2fc16e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f76940cb115b08d88945ebb33b4c8ad9f102802a85bc877f27d23dde307d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71742a030ac9c8fd9fa4880ed9d963552e1239e8a6c9344b38555a9656134b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf319e52687c1e13009f703ec64bb704869346cb2ab49ec06c5d171b49b0212"
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
