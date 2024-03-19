class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.21",
      revision: "42667dfeca123234e4e85946df22bd01406cc4f9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "562949ae2adcf6fa839d73771ed358539646f71db78986546662c31760d6eac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "562949ae2adcf6fa839d73771ed358539646f71db78986546662c31760d6eac5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "562949ae2adcf6fa839d73771ed358539646f71db78986546662c31760d6eac5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a3b650f13d205ae6ad49b8f27dad84d4044e955e976cfba4ab5dab37bbd91f7"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3b650f13d205ae6ad49b8f27dad84d4044e955e976cfba4ab5dab37bbd91f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3b650f13d205ae6ad49b8f27dad84d4044e955e976cfba4ab5dab37bbd91f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d501a385237f2fac1f19ee0f991c1702620e339d54cc535c3a58d82e40ff9f"
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
