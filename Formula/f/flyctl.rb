class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.115",
      revision: "a5404d786e39d4f8989f26c992f08d3e3b632e6b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b5d06cf11bae603965263e17dc0bb10fec13666bb5c345c2eee7e5e95d4c0cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b5d06cf11bae603965263e17dc0bb10fec13666bb5c345c2eee7e5e95d4c0cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b5d06cf11bae603965263e17dc0bb10fec13666bb5c345c2eee7e5e95d4c0cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71cd2b74e86121861aef691ad2dc2b9f6c6745869a77e896fc1d834f74535b3"
    sha256 cellar: :any_skip_relocation, ventura:       "c71cd2b74e86121861aef691ad2dc2b9f6c6745869a77e896fc1d834f74535b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3331b900c2281281aab5afe49c918dbd7381a53a281a4f1e12c54fcc418595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e37bec249032a2b95526d4a093985f322831d45a02487d825398981d4b2d13"
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
  end
end
