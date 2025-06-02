class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.135",
      revision: "53cac93a1608223a2c766daa2769424e526b4179"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2552ac4495f709378642c5c96c6ccfc6c8ebdf33cd867d738befa8d4a7318923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2552ac4495f709378642c5c96c6ccfc6c8ebdf33cd867d738befa8d4a7318923"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2552ac4495f709378642c5c96c6ccfc6c8ebdf33cd867d738befa8d4a7318923"
    sha256 cellar: :any_skip_relocation, sonoma:        "0527a46ac3e4a9acbaed0496a06fa963f6cea87b14db1f906a82aff16531a89e"
    sha256 cellar: :any_skip_relocation, ventura:       "0527a46ac3e4a9acbaed0496a06fa963f6cea87b14db1f906a82aff16531a89e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9187f3b3ca9cab02e8ed5c9a61f4f90143ff1ccecb184889164482522aec64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1cf1908761de1ec5e25695b36e293122606d7105701ce1b07d2facf6598019"
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
