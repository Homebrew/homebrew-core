class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.24",
      revision: "e3b617fe12cf1f641180fbf21714e8fd14e4215d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d3778548e456e246a5780424023b580e3012bf13293c37bd5cd4ca342d1e646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d3778548e456e246a5780424023b580e3012bf13293c37bd5cd4ca342d1e646"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d3778548e456e246a5780424023b580e3012bf13293c37bd5cd4ca342d1e646"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf81efa3494b86c3a71835a02c58fee57c7651218b2224b6ade356f9fc15322"
    sha256 cellar: :any_skip_relocation, ventura:       "4bf81efa3494b86c3a71835a02c58fee57c7651218b2224b6ade356f9fc15322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c325ca202775aa86654e4d015d5c7b525124362d7e34e2ff9154c9d6d499e113"
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
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
