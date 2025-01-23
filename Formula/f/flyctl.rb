class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.67",
      revision: "9edab547c842280e9f06f87da0e2293638baa720"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edee0678e1c552497b2530a6a96541b016af6aeeaa7e18fb0488f261b462cff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edee0678e1c552497b2530a6a96541b016af6aeeaa7e18fb0488f261b462cff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edee0678e1c552497b2530a6a96541b016af6aeeaa7e18fb0488f261b462cff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b45408afa5eb845bebe30fbf72db1d1793476b04ebec9574b62c049fa890f0ea"
    sha256 cellar: :any_skip_relocation, ventura:       "b45408afa5eb845bebe30fbf72db1d1793476b04ebec9574b62c049fa890f0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d62ea6f6696754121ec63660a8187316e766c9431e2cd9feadd0174a7073d3"
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
