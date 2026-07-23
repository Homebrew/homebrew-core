class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.74",
      revision: "b74c9391409b3e443383a5f4d928cef007825ddc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b26198c119ec38383ee9ec743fbfd2a0d79627c33354c59aa8297cbc1327182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b26198c119ec38383ee9ec743fbfd2a0d79627c33354c59aa8297cbc1327182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b26198c119ec38383ee9ec743fbfd2a0d79627c33354c59aa8297cbc1327182"
    sha256 cellar: :any_skip_relocation, sonoma:        "b033c77a230843fcb336b66be6972d7d6cdfd6759bf415c51c559aad3230e463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ba88684911409040534cb284c0238bfc67c3975227db5bb688d8bfee05b06de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc674aeea10e74f6f7499e1b3414ba80b06fc4af52d0a46f043c1fee5e23246"
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
