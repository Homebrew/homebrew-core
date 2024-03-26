class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.25",
      revision: "358c5fcbcbf3b9edfab38ba8f5e305c8b786231e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdda99ded926385ab534a42b536ea741874bf8735d343791aa87947a9cf97891"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdda99ded926385ab534a42b536ea741874bf8735d343791aa87947a9cf97891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdda99ded926385ab534a42b536ea741874bf8735d343791aa87947a9cf97891"
    sha256 cellar: :any_skip_relocation, sonoma:         "e83adaf472ec837e3bd47285ae77faee7614adf6ddac440a75f8fea5e562cdfa"
    sha256 cellar: :any_skip_relocation, ventura:        "e83adaf472ec837e3bd47285ae77faee7614adf6ddac440a75f8fea5e562cdfa"
    sha256 cellar: :any_skip_relocation, monterey:       "e83adaf472ec837e3bd47285ae77faee7614adf6ddac440a75f8fea5e562cdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4332bbbe2949c0539163cbd19a75967330dd02c2cd5d705d61f42c92e9a73a67"
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
