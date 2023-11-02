class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.115",
      revision: "f319604141d1646d8c9c256017874cb10fa325b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0e36f9d22aff083997d879fab3deb08034a51db347e49375574ea5a7fbb3b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e36f9d22aff083997d879fab3deb08034a51db347e49375574ea5a7fbb3b29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e36f9d22aff083997d879fab3deb08034a51db347e49375574ea5a7fbb3b29"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c4498081be6edeb476fa90a7f5a27b99e26e58af00a7e5d0576419b9978941d"
    sha256 cellar: :any_skip_relocation, ventura:        "9c4498081be6edeb476fa90a7f5a27b99e26e58af00a7e5d0576419b9978941d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c4498081be6edeb476fa90a7f5a27b99e26e58af00a7e5d0576419b9978941d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13cc053a6ef1a47bedf65e0a5a0040b30a85ca13caa9edf111986dd068642823"
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
