class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.180",
      revision: "5c11421b5f562b2032f4c6fde217a76e919de095"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d34918474e3ca3ad911003dcc6f479c6cc66af7cd2c700992de8d2b5a084b50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d34918474e3ca3ad911003dcc6f479c6cc66af7cd2c700992de8d2b5a084b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d34918474e3ca3ad911003dcc6f479c6cc66af7cd2c700992de8d2b5a084b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5046a6a552e0b5f9e6addaf8feeb06021745b2962ebd1ed9ef00638f8e7668a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873c87f4ef8fe44bc494e61647f0e1db2992258a36a6178143ecbecf7707a1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3bbe3f8f150efa95d662c400ca94e57bd4b889f0bd8093772321fc1c4a3fff"
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
