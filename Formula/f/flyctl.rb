class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.4.25",
      revision: "7ccf47c84e576aec7e18ba781e1f58cb0ada11e7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1248eef4ee81d8c8917929c076f07fa442a344cad567eee9e45f745a166e296e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1248eef4ee81d8c8917929c076f07fa442a344cad567eee9e45f745a166e296e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1248eef4ee81d8c8917929c076f07fa442a344cad567eee9e45f745a166e296e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8afb54b464509641f3ef0d78830fc2e28fb5b9ca0e4c6cda604a9dda5af16bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad7874e3b2a0aa7126730c28de59d3d75aae97ef6fdeec274ac296df64476f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025c3f5fb006b4069c0cdb6b4fea302b1716fafd8cf1c25e22ce4d731d8186c3"
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
