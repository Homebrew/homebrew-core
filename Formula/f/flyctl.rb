class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.65",
      revision: "11012261a75046dd811e51aa7ab3044459719844"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a360d09a1a2077b2244cf4f36900a6d5fa5825bebe06fd24994868e67be29a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a360d09a1a2077b2244cf4f36900a6d5fa5825bebe06fd24994868e67be29a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a360d09a1a2077b2244cf4f36900a6d5fa5825bebe06fd24994868e67be29a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb604659a10c6998fbea68d24f3849e0d10f08190ffad7dbbfdfef622a9a5f00"
    sha256 cellar: :any_skip_relocation, ventura:       "eb604659a10c6998fbea68d24f3849e0d10f08190ffad7dbbfdfef622a9a5f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e66cea12ba40f99f31f0096c249bb76d7bc557ab302236b3443d1289912de7"
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
