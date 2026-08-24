class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.87",
      revision: "3eb236fab6a9226928554243ba163e5fb13aa3a4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0497c9cc140a40ece854389cf826eeea190f9aae05aba0a54345ca625507fc89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0497c9cc140a40ece854389cf826eeea190f9aae05aba0a54345ca625507fc89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0497c9cc140a40ece854389cf826eeea190f9aae05aba0a54345ca625507fc89"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb2606a8c8eeda8b7d9b95e2b878c6c20b3f1172e65f22f5b33bbe1971e02ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a650b91145a7746c5a7f34a33215b00c0e4192b3221bd0e4f160cdd596fdea40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81a6add2c4ebf041b9b629ac2bdd3e1fe55e1911211a605f6ed88b501aa2b06"
  end

  depends_on "go" => :build

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
