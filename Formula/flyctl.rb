class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.482",
      revision: "0f706051ece0688fff86205b8b2a7a1f731aa963"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28bf7782dd9cf507a0192e05b90e49dedd1105d3a46853f902b12d039b210794"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28bf7782dd9cf507a0192e05b90e49dedd1105d3a46853f902b12d039b210794"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28bf7782dd9cf507a0192e05b90e49dedd1105d3a46853f902b12d039b210794"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0dff0fcab4d739408676e10ee7ff63e2ddc8a932ca090d4670c6c77b1ac32d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0dff0fcab4d739408676e10ee7ff63e2ddc8a932ca090d4670c6c77b1ac32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb0dff0fcab4d739408676e10ee7ff63e2ddc8a932ca090d4670c6c77b1ac32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1285961d7ba274e2c26ee2aed8e769558bdeb0edc8dfd91bd32218d75e66e4fe"
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
