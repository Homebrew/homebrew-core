class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.34",
      revision: "a9443bba9e4740b675dc48be4286a45670345dd6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b9b89b5212c328a15f48b458b15f2b3c83f652974b21ca5c748ea5ce05a898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b9b89b5212c328a15f48b458b15f2b3c83f652974b21ca5c748ea5ce05a898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b9b89b5212c328a15f48b458b15f2b3c83f652974b21ca5c748ea5ce05a898"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b91059a7d3dd4a2fb59f329ca30597738221150bb4e9307fbf449b679243ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "8b91059a7d3dd4a2fb59f329ca30597738221150bb4e9307fbf449b679243ac1"
    sha256 cellar: :any_skip_relocation, monterey:       "8b91059a7d3dd4a2fb59f329ca30597738221150bb4e9307fbf449b679243ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5002980b1e205446776d7cbd93059914f2af7203733a9e2ebcf825ce2f64fd2"
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
