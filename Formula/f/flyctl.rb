class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.12",
      revision: "a1d8d54dd741184490dd262234e31dcfbb3e9a75"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92ad9b34801cea64449ae7330521a521e226fbddaa8f8be7c83db2f6f92248dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92ad9b34801cea64449ae7330521a521e226fbddaa8f8be7c83db2f6f92248dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92ad9b34801cea64449ae7330521a521e226fbddaa8f8be7c83db2f6f92248dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce8afd73dc3c472a600e243be2152a404a7bb8cb2439ec07b1f39fbc20927b57"
    sha256 cellar: :any_skip_relocation, ventura:        "ce8afd73dc3c472a600e243be2152a404a7bb8cb2439ec07b1f39fbc20927b57"
    sha256 cellar: :any_skip_relocation, monterey:       "ce8afd73dc3c472a600e243be2152a404a7bb8cb2439ec07b1f39fbc20927b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22f7d2a8c99867b452329585e93e87227dbaf7784e7e166a5d4a5eeec18b35f"
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
