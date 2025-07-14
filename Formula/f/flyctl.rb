class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.154",
      revision: "9510905550621b4d2e2d64783477e798f602471f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d8810aeb483941f4af1728f4beb81313ee85c8853d917570cf94f69ab95b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d8810aeb483941f4af1728f4beb81313ee85c8853d917570cf94f69ab95b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8d8810aeb483941f4af1728f4beb81313ee85c8853d917570cf94f69ab95b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3994c01e1482c2de1469d65167f99b97b2db5ba0ada1afd0d40b1b8652b700c"
    sha256 cellar: :any_skip_relocation, ventura:       "c3994c01e1482c2de1469d65167f99b97b2db5ba0ada1afd0d40b1b8652b700c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d99488a6a2451dfb79341affa2fa4cf0ed4f4e2b284761798bbe124129d1571e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "547be9afc63009667f91ab8d2bb8e8e6ec4d1c2628beef8f5c40f090636a19f9"
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
    system "go", "build", *std_go_args(ldflags:, tags: "production")

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
