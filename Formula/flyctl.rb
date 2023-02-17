class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.459",
      revision: "7f46b91869aae79569ef2bb5a185a6a37874a3ce"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6f0a341a92b94f9573631d5ad625c96a5d58431f204bc10b48153d440b80a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6f0a341a92b94f9573631d5ad625c96a5d58431f204bc10b48153d440b80a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e6f0a341a92b94f9573631d5ad625c96a5d58431f204bc10b48153d440b80a1"
    sha256 cellar: :any_skip_relocation, ventura:        "771d23ee6278b3dfb5b286e46954eef933c15edea1e1ba84db2853562cdc39b4"
    sha256 cellar: :any_skip_relocation, monterey:       "771d23ee6278b3dfb5b286e46954eef933c15edea1e1ba84db2853562cdc39b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "771d23ee6278b3dfb5b286e46954eef933c15edea1e1ba84db2853562cdc39b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49abf74ec71d30e402c30d53f21d95c672a45b318532ddaca6ec8c904d434a44"
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
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
