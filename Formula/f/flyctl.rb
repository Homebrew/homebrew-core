class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.9",
      revision: "3fbcdb941df8e5e46a3d11a85404004b86e91dd3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d80e8a2de164ff5072466702a95d93a84e9cbf854fe23de90a07d16669baadea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d80e8a2de164ff5072466702a95d93a84e9cbf854fe23de90a07d16669baadea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d80e8a2de164ff5072466702a95d93a84e9cbf854fe23de90a07d16669baadea"
    sha256 cellar: :any_skip_relocation, sonoma:         "2004c093faab3490a1bd3fbb2c40634171c9ab9001e3bfea263901d0c85ebb19"
    sha256 cellar: :any_skip_relocation, ventura:        "2004c093faab3490a1bd3fbb2c40634171c9ab9001e3bfea263901d0c85ebb19"
    sha256 cellar: :any_skip_relocation, monterey:       "2004c093faab3490a1bd3fbb2c40634171c9ab9001e3bfea263901d0c85ebb19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4a154f63e62b8283345baa456bccb0fc4096cb2b6dbf5db19b54bf1c35ff48"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
