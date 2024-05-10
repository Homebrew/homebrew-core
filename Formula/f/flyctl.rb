class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.50",
      revision: "28937186d0e759b2060db699e98bf13c688d5d4f"
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
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f07fe5955437dc62d04c9354a3892180e6f7c598c74f80bbf50fb1dc4f92eb48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2476ea9b8b52e7260ba7a06cf8b5cb61fdbd357c86dce45a94e25e0dbd418d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6a81fa01915c157a88676e12ee0ec76a9d2033bfe9215a20504a79faea5a75f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f67fa6e303c3a9e73fc24180e019ac0bdb77b40fc5dd053f445e28382c9e4bb"
    sha256 cellar: :any_skip_relocation, ventura:        "e164c90124559bbadd40e6c6e13af8370edfd9360e3681dfb3b935f3ec97164b"
    sha256 cellar: :any_skip_relocation, monterey:       "8872681856046f698279ce723c02ef7b57f190735c42d0295886b3a25fca2262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065be4f43c5792bcaccd186c7a0175ee412b6db5848ff4bf6906a49b098f7d13"
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
