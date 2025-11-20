class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.221",
      revision: "4026f47406aaea08fa1773b432b6c44b9295a0dd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5a70ab24a6d6331a1307e54004444b097b92d16af6ed2061a7c854792b9fe8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a70ab24a6d6331a1307e54004444b097b92d16af6ed2061a7c854792b9fe8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a70ab24a6d6331a1307e54004444b097b92d16af6ed2061a7c854792b9fe8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ea831dda8e766f1c02fa903b500f27c3b6eb64b977ba1af53edfffb1eefd7e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d7997f01a725ceac1257434ca8a145bcd7d4080aff6e0854a705846ffb699f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb80f783c1a470ee48f2e0940158e2c37da1d855d74232230ad1a7fee61b719"
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
