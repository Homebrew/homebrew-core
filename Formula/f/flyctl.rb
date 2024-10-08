class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.16",
      revision: "d59a12fb0d2c6e2196d1a4b3faa55b11ecd98d38"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f6c09e0caa44f74e4ee1795d21efcba3b6552202671e1cdb8c2907fbd55107d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6c09e0caa44f74e4ee1795d21efcba3b6552202671e1cdb8c2907fbd55107d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f6c09e0caa44f74e4ee1795d21efcba3b6552202671e1cdb8c2907fbd55107d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e48443a40a6ea3a974181efd7de45184bd3dbd347c76164854b40eb47d7082b6"
    sha256 cellar: :any_skip_relocation, ventura:       "e48443a40a6ea3a974181efd7de45184bd3dbd347c76164854b40eb47d7082b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2a573a417368c9fbe777925031ed5796be1a3d9f8a92f06ec07ce93ea3f4931"
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
