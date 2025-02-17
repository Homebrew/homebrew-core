class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.82",
      revision: "b657dad03b989fa859aa6434f937975647468692"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80397cbd874d7d3d57a28ce4037c58517f5ac254d3094a875e9a12d78c22055a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80397cbd874d7d3d57a28ce4037c58517f5ac254d3094a875e9a12d78c22055a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80397cbd874d7d3d57a28ce4037c58517f5ac254d3094a875e9a12d78c22055a"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ab3e2d67dc14331ab17207c7e6312d046941b6901501b24497ee437e2a6b06"
    sha256 cellar: :any_skip_relocation, ventura:       "08ab3e2d67dc14331ab17207c7e6312d046941b6901501b24497ee437e2a6b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b45137ec2ca6d34813a05e7dcfc1503738f885b1e9bd7821d95260da0a38c6"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

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
