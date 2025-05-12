class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.120",
      revision: "498db94b9b6a33511096494e4d5b29ed4684d3c0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf9d14e623e76673c4f40283cc680a415eeac6cb8916fa21c385798a1876f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adf9d14e623e76673c4f40283cc680a415eeac6cb8916fa21c385798a1876f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adf9d14e623e76673c4f40283cc680a415eeac6cb8916fa21c385798a1876f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec44f2115cfe3af942f886363ebac48ee0e7250378731ffdfbd675c6be17dde2"
    sha256 cellar: :any_skip_relocation, ventura:       "ec44f2115cfe3af942f886363ebac48ee0e7250378731ffdfbd675c6be17dde2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f27a9b5e39f1929517522a894446035d4a2da86e40d09896a5d628784ed4b146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c6393bd8a6b8feab8ef64e7fd5b69fd18ecb9998b64e239ef515318cce9b05"
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
