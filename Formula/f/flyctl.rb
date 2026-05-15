class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.52",
      revision: "e4090acb4e44253c06c85816d88ca4ad8422db07"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57edadf146ab47cdf43cafbe73fe35036e0b0914b1dba2dc87d8e08993a0b8bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57edadf146ab47cdf43cafbe73fe35036e0b0914b1dba2dc87d8e08993a0b8bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57edadf146ab47cdf43cafbe73fe35036e0b0914b1dba2dc87d8e08993a0b8bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "46009f9b2783254416f555fc9893db7af80b041af8197ba7b3c47b64c226f408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0deb52b1fb3cb699c39fbcb7ca5429c537ac78e2007721313537defbd6b9828d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773020a649219a3820da1c4851e47f67a5e395b92f78b9a4af6a63655eca2053"
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
