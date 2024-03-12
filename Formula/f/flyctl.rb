class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.17",
      revision: "3a51f42f15355928eb7f51c620f599328cadfa55"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78995991d4a73f4c38a299e8dbaf7813bea7d55abc4cb288050b3a10ba3c21ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78995991d4a73f4c38a299e8dbaf7813bea7d55abc4cb288050b3a10ba3c21ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78995991d4a73f4c38a299e8dbaf7813bea7d55abc4cb288050b3a10ba3c21ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc66c41da97cded7ad8474409b5cd90a12143e6c8b33f9e3fdd80dba2a78477a"
    sha256 cellar: :any_skip_relocation, ventura:        "fc66c41da97cded7ad8474409b5cd90a12143e6c8b33f9e3fdd80dba2a78477a"
    sha256 cellar: :any_skip_relocation, monterey:       "fc66c41da97cded7ad8474409b5cd90a12143e6c8b33f9e3fdd80dba2a78477a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712a1d7642454eb2c957d4119f985294a14e9f33288af80cb32ae4df4c866f66"
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
