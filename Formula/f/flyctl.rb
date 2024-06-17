class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.69",
      revision: "f2d3a9f830da5f92ad060f0d3ebbf433dda0df30"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d2c00a2e9e4e08bbe5026f56a92bf305c6722c74fa389283376284611cb5e71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2c00a2e9e4e08bbe5026f56a92bf305c6722c74fa389283376284611cb5e71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2c00a2e9e4e08bbe5026f56a92bf305c6722c74fa389283376284611cb5e71"
    sha256 cellar: :any_skip_relocation, sonoma:         "b09614dd7ecd3e7b04073599eb2a151589883dd0904e99dc08cc9ab93e5173af"
    sha256 cellar: :any_skip_relocation, ventura:        "b09614dd7ecd3e7b04073599eb2a151589883dd0904e99dc08cc9ab93e5173af"
    sha256 cellar: :any_skip_relocation, monterey:       "8ddc8c2b0e42bfacd4be2f8138fcbe150fc13b1939878efbbafe1447e9372ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba806bab669bdfebd289ec3dd9c3c9ab5134a550d77a077463d1b6437acace19"
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
