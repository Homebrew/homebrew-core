class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.58",
      revision: "db504b138ffaab0d212428806b25f9d1dea5d593"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c658951c286d06db2933effc0b5990848c70580c0b5ecffc31e2aed763e47b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c658951c286d06db2933effc0b5990848c70580c0b5ecffc31e2aed763e47b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c658951c286d06db2933effc0b5990848c70580c0b5ecffc31e2aed763e47b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a66507508f12188b262323b94cf8cf49c4abb2f32cffc7dc983a30d874ca831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be0e876c6abda60990028dfb6144b06c0ebfa6c90d341ca2bec6b12d5253080d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d6b81b15e6a658c3c90173c37f78b5a106af1e41fc5bd3c0fe914e1140488a"
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
