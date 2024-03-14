class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.18",
      revision: "1ce9d2b9d1b36d52fa7b5880f785aa8fdb77b874"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e72ca8f7cce0a7d53d395d40fa306b0da06409ddf13f9bec552734d360408df0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72ca8f7cce0a7d53d395d40fa306b0da06409ddf13f9bec552734d360408df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e72ca8f7cce0a7d53d395d40fa306b0da06409ddf13f9bec552734d360408df0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ead1a39fe5b33ce863832164b4c8897ab9e801e865241c73ad8e1faf2bfde933"
    sha256 cellar: :any_skip_relocation, ventura:        "ead1a39fe5b33ce863832164b4c8897ab9e801e865241c73ad8e1faf2bfde933"
    sha256 cellar: :any_skip_relocation, monterey:       "ead1a39fe5b33ce863832164b4c8897ab9e801e865241c73ad8e1faf2bfde933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e77dcb8b79d714acaba319896e6971b3eb3d9af3b545c77e0ace7d29ff8bc079"
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
