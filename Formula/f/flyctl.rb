class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.5.7",
      revision: "bd632cf8d6f5d9c2600f2c0bc355902002dbb2bc"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01fccc4f7fb056d6a7855ef647c7d1b4dc7fa35dbeae9555ec48bb5ca46808ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01fccc4f7fb056d6a7855ef647c7d1b4dc7fa35dbeae9555ec48bb5ca46808ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01fccc4f7fb056d6a7855ef647c7d1b4dc7fa35dbeae9555ec48bb5ca46808ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05d4454d461f329404ad476b3e309f2259a5824463f95101e6404f2f0d87f6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "679a92702bad4fa45a7514de760afadc09a00034cb72362cc72a6998cf9b6bc6"
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
