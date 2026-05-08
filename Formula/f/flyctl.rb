class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.49",
      revision: "fd07d818e8678f0ea9e9111e0f367a3a16973a06"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a68ed044a4d1e484298d1d60c418706921d661014588a3b3e558858a0c32f887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a68ed044a4d1e484298d1d60c418706921d661014588a3b3e558858a0c32f887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68ed044a4d1e484298d1d60c418706921d661014588a3b3e558858a0c32f887"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cdb91ba2940c0177222b13e2c4acffb037f23d088184350067307e36dfa9dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1afd19c120bbd40ed56f639071edd0c0a39923ee78db114e704e2349bfd3f0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "376a932c035deb28b27dbede66ee425d29c7d9aebdbaa7dbe0c322a386732ded"
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
