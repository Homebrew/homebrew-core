class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.40",
      revision: "3003fb629cdab7d5e44838f7c1de4aee44886e71"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eed62c7c619f2b4f114129f26040c21b376ff05f14c2f2587080b5c71d7840f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed62c7c619f2b4f114129f26040c21b376ff05f14c2f2587080b5c71d7840f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed62c7c619f2b4f114129f26040c21b376ff05f14c2f2587080b5c71d7840f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe13c3444179d3860e7247d1c5dd698845f46edabfcdf2552a1ccd4c2237406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a059fb7b5b881b780e1493f208fdedeb3c15a6aa96a10a87c78c8d75d552a678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a428e90c304951b7f5ab0b4245a186c001e792fde84be7cadadf13050fcd3e21"
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
