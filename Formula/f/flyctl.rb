class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.3",
      revision: "f58ce93c269bf5211a4dba0454631d94e5123dfc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ce6c8d9b6b0aee0cc4d2ec2fc4625a7371ec569bb9927ccbd883babf85a6d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ce6c8d9b6b0aee0cc4d2ec2fc4625a7371ec569bb9927ccbd883babf85a6d52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ce6c8d9b6b0aee0cc4d2ec2fc4625a7371ec569bb9927ccbd883babf85a6d52"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd7ebae175d0e32aba21e40931709ead9eeb5db08194555d87e43afdfd254701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "613ba1ad242438cc34c2486974296e2e106b3f856676034e60aeffd64d99bbf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18119409c72bc5d35a75ab95aba5a141e458a759c20c515b6bb0126875f1c895"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Create a new Fly.io app", pipe_output("#{bin}/flyctl mcp server", json, 0)
  end
end
