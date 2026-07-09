class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.68",
      revision: "6b534abd4fd08e94b0cd28a6d04b662d8e1246d8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2964b73ed495091964fe6c6a5717670744a80d4d58002d54e9fe4b4b31d62d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2964b73ed495091964fe6c6a5717670744a80d4d58002d54e9fe4b4b31d62d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2964b73ed495091964fe6c6a5717670744a80d4d58002d54e9fe4b4b31d62d"
    sha256 cellar: :any_skip_relocation, sonoma:        "12987f78784b67efa786a976408b771f501e1d54c6a2a5feff6bf7add9b2e6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42bc66c16538540b66d55043b62d9d53f3c9a2dc8c8d4b20f3da6e9814834637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accc57b3f2b9b8eae25de080ec53d5ccbe128b07e6a3bf10cfb45f317e5508c4"
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
