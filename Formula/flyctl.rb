class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.479",
      revision: "5267c150cd509205c9074fc199ffe3aa930b5345"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f78e16a365298a1ebe754b904d597b13f7dd812c5c037d9a3ba9a274efc0f16f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78e16a365298a1ebe754b904d597b13f7dd812c5c037d9a3ba9a274efc0f16f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f78e16a365298a1ebe754b904d597b13f7dd812c5c037d9a3ba9a274efc0f16f"
    sha256 cellar: :any_skip_relocation, ventura:        "1f72e8d3fcd46eb18e5049ea42389031aac6f65a275bf5db7851734b34d93693"
    sha256 cellar: :any_skip_relocation, monterey:       "1f72e8d3fcd46eb18e5049ea42389031aac6f65a275bf5db7851734b34d93693"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f72e8d3fcd46eb18e5049ea42389031aac6f65a275bf5db7851734b34d93693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba84125efc1e755bcd58c6d1a1ecffec5f08542dbb183c9f6a563397e5fb5d5"
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
