class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.19",
      revision: "19716fc4f41e2d20cc15385c07d3209f9ca5752b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e154b3852a737ea9e95dbf56666acff1925efbf74e08adc87b57b16cf9049651"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e154b3852a737ea9e95dbf56666acff1925efbf74e08adc87b57b16cf9049651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e154b3852a737ea9e95dbf56666acff1925efbf74e08adc87b57b16cf9049651"
    sha256 cellar: :any_skip_relocation, sonoma:         "b70e37e3027476a1c383440a459965022aaae97dcb130a2a9616476ab9780f9e"
    sha256 cellar: :any_skip_relocation, ventura:        "b70e37e3027476a1c383440a459965022aaae97dcb130a2a9616476ab9780f9e"
    sha256 cellar: :any_skip_relocation, monterey:       "b70e37e3027476a1c383440a459965022aaae97dcb130a2a9616476ab9780f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11007143f32cf2fb74be217b0e414624e45d27acb75c5d2d6e9dfb46aa7ed542"
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
