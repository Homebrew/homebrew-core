class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.187",
      revision: "72f99ca44cc37e250dcdf4c6dd370948acc088df"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0cf68859cf3e7c19a773e44818fad44cfa89db2d9c6ebdb910c0ef861ad880c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0cf68859cf3e7c19a773e44818fad44cfa89db2d9c6ebdb910c0ef861ad880c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0cf68859cf3e7c19a773e44818fad44cfa89db2d9c6ebdb910c0ef861ad880c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1d829e4cb0a9d331b77f729c740d04efab8324f9eb9ea4ac88f7cbd35d28fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b332a00520f3fc9f9d4e83c73c5affd9ed249635c2676d8f84c462883629a530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec9e61fc7175a95fbc7bc9fd55b01dd6c50f4b8bb6c92f4f94f5a922e09d764"
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
