class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  # flyctl should only be updated every 5 releases on multiples of 5
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.101",
      revision: "f1a45f120132eb36d131ebc0f620870f24eaf9a5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962be19fe7d5f3d746b490424a6f5f1f6533e0e990cb1dbb1bed62ff1dc8387c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962be19fe7d5f3d746b490424a6f5f1f6533e0e990cb1dbb1bed62ff1dc8387c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962be19fe7d5f3d746b490424a6f5f1f6533e0e990cb1dbb1bed62ff1dc8387c"
    sha256 cellar: :any_skip_relocation, ventura:        "e62b6976af564abf3e9d352211e200f49f738902a2bc96b8ef53d6a8cc2d8157"
    sha256 cellar: :any_skip_relocation, monterey:       "e62b6976af564abf3e9d352211e200f49f738902a2bc96b8ef53d6a8cc2d8157"
    sha256 cellar: :any_skip_relocation, big_sur:        "e62b6976af564abf3e9d352211e200f49f738902a2bc96b8ef53d6a8cc2d8157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a27681289423ceb46838b50f4d90976d416b302f37b61d1aed25ff01f6f7121"
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
