class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.174",
      revision: "360de21945d494132c4d43d0f6ba1fde1637f59d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99ed8bc4e6759d0f38d3bcc84a3cc8cb643d199e33a3863aa492a0ba986fbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c99ed8bc4e6759d0f38d3bcc84a3cc8cb643d199e33a3863aa492a0ba986fbe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c99ed8bc4e6759d0f38d3bcc84a3cc8cb643d199e33a3863aa492a0ba986fbe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1645ea969e7bc36b43ba9bcd849e101fe21aa46f6e942fc7e35485adeb91d5b"
    sha256 cellar: :any_skip_relocation, ventura:       "e1645ea969e7bc36b43ba9bcd849e101fe21aa46f6e942fc7e35485adeb91d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10049ecb6aaf99bfcaf149b636f1cabc194b5a196dec9c0cfcf4431de7c9e668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5676798d037b29a5ba6066cbdba507323dc324c980295c8f397d9496d580f8cc"
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
