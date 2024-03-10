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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0872994d9994b605045d2a5f728e043236b82d3e3cdb616636f8ba4e50a0c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0872994d9994b605045d2a5f728e043236b82d3e3cdb616636f8ba4e50a0c96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0872994d9994b605045d2a5f728e043236b82d3e3cdb616636f8ba4e50a0c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "b82d97bf1e08cd5309d1ee6a054b1c0ab62e194d0d092acc1f7746e975248301"
    sha256 cellar: :any_skip_relocation, ventura:        "b82d97bf1e08cd5309d1ee6a054b1c0ab62e194d0d092acc1f7746e975248301"
    sha256 cellar: :any_skip_relocation, monterey:       "b82d97bf1e08cd5309d1ee6a054b1c0ab62e194d0d092acc1f7746e975248301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93f1908132fae62592c0bd8e1aca9893ae2fe902d8acd16332a87dafd29672f"
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
