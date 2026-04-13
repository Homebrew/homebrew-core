class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.33",
      revision: "44d56a688d1a979601017402965a6367039b2b72"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e543a251dd131efb497b8a81104c05839f9b58393156b89088622f8ff8ad8471"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e543a251dd131efb497b8a81104c05839f9b58393156b89088622f8ff8ad8471"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e543a251dd131efb497b8a81104c05839f9b58393156b89088622f8ff8ad8471"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b19b73c7a72470c79ed4b962259abb011a9d98942d5851113511a1ca7fc67d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b05334bf8e898831a761e5bda4c384a9ca2e5ae755ccf8e5ffecd86d0146395e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc48707c8151f95282df4c09e56a2eb5a9fa4a392c552f14f7d869a002b8ada"
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
