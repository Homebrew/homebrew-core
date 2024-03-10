class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.15",
      revision: "846630217aff135b32ec0d6a018cf6bdde0f1762"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ba6cf067a3657e8c2f8bbec9060d2f42700e96ea8061683c950849f68da79c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ba6cf067a3657e8c2f8bbec9060d2f42700e96ea8061683c950849f68da79c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba6cf067a3657e8c2f8bbec9060d2f42700e96ea8061683c950849f68da79c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f266da2b415f974c4791e58f7e6f070533ef61893da4d76e5d181a2c005c7071"
    sha256 cellar: :any_skip_relocation, ventura:        "f266da2b415f974c4791e58f7e6f070533ef61893da4d76e5d181a2c005c7071"
    sha256 cellar: :any_skip_relocation, monterey:       "f266da2b415f974c4791e58f7e6f070533ef61893da4d76e5d181a2c005c7071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b066f4f2b5a648e34eb18c1030a3bfc376501b1cce66f48da6aa77db3ed43cde"
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
