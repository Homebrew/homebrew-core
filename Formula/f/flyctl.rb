class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.41",
      revision: "440fc7c056e8f9bad3ef1c0f5f810f242eb1a797"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ae5daa44f918a9d7cea181621aa273f3d7323a7f9751c5a9f8d0e37562ff3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ae5daa44f918a9d7cea181621aa273f3d7323a7f9751c5a9f8d0e37562ff3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31ae5daa44f918a9d7cea181621aa273f3d7323a7f9751c5a9f8d0e37562ff3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02841229a70b1714b81ff875cf651160ed59fcbaf827df9432dd9c2b847b49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25de94298a41b4426acb72a514434939a4d952c8d1d424a20c3dc89729248f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f246309bffae027a312da81df3c0e1091ebb5d54fbab646e16a6d25ba9b056b8"
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
