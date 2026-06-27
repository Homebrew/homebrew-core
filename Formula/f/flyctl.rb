class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.61",
      revision: "1ac1f449b981403ceede52477289e3f6f548cfca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60385d19bac313bdc011c0d49a6d43dba978aa14e157a850e0f7d8c2cb2d11d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60385d19bac313bdc011c0d49a6d43dba978aa14e157a850e0f7d8c2cb2d11d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60385d19bac313bdc011c0d49a6d43dba978aa14e157a850e0f7d8c2cb2d11d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "834a194fe3dcf0e0c58d54ae093d4cc4f4adfdd855a7e51ae409f690be9777b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ca8da313c90b932786a2c6ae57eb31112782666f9fdc8cf880adbb94fd41a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914b816e24493a3cc51a6f6d334de58b3cc585b2393d74a05ce360653c3da1ec"
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
