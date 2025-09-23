class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.182",
      revision: "f4d922d9019c1d6e58bdd97881e78db580521255"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48908fe1adae6fd25aff01cc0e80f997001db735ec2f8bf9340174350701e2a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48908fe1adae6fd25aff01cc0e80f997001db735ec2f8bf9340174350701e2a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48908fe1adae6fd25aff01cc0e80f997001db735ec2f8bf9340174350701e2a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f3a7ed14ae30cf8d8b227d3709926fb553e65e820e3a08d1ccdf0b318d0fd58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38ffd5e1f6cd4f68fe64f27e9fcda213524688885210c213fb97f9cbb6426ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a2499245bd9d8ffdd28d8b32e9fa8c67c2fb8a7f6dc9f8697136329955965a"
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
