class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.97",
      revision: "4e09fc60ad452dda368372a9767386d8a5c0549d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a69609168ccba53124a0473a155344589d085eb40b47dd35b0e56cef0f4873a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a69609168ccba53124a0473a155344589d085eb40b47dd35b0e56cef0f4873a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69609168ccba53124a0473a155344589d085eb40b47dd35b0e56cef0f4873a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a69609168ccba53124a0473a155344589d085eb40b47dd35b0e56cef0f4873a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "64c756ec80a07b272eb42c1e3fee9decd4574abe67cc3659fe1eecc14d493a25"
    sha256 cellar: :any_skip_relocation, ventura:        "64c756ec80a07b272eb42c1e3fee9decd4574abe67cc3659fe1eecc14d493a25"
    sha256 cellar: :any_skip_relocation, monterey:       "64c756ec80a07b272eb42c1e3fee9decd4574abe67cc3659fe1eecc14d493a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c756ec80a07b272eb42c1e3fee9decd4574abe67cc3659fe1eecc14d493a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7208c446edaf621f93589feb8cba8e64007f26bfb259616ffb975920d69c3dd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
