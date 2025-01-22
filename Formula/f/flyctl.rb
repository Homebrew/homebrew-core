class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.66",
      revision: "0e171f471be2eed90d0c6bad481b894f952098ca"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dba888f0113e0a2f8ed410e15d916be56d447e6661a138272f6b9b55afde1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dba888f0113e0a2f8ed410e15d916be56d447e6661a138272f6b9b55afde1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dba888f0113e0a2f8ed410e15d916be56d447e6661a138272f6b9b55afde1d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0060a2697c87e6beaebfb632bc1da091ca19583464aedf276d046a7dab240fbe"
    sha256 cellar: :any_skip_relocation, ventura:       "0060a2697c87e6beaebfb632bc1da091ca19583464aedf276d046a7dab240fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa071d214f3e1a8ba1b8c4f304ef134a7aaedec39b28244d0b4cd80e74e2626"
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
