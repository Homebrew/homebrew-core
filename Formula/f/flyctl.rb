class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.114",
      revision: "de9e822f435d145ba4def9ef63cb94a35383b461"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd5ebc9e5d62ae0bd61fc881e23b905b7c987cedf16f51c36224b798964c76b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd5ebc9e5d62ae0bd61fc881e23b905b7c987cedf16f51c36224b798964c76b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd5ebc9e5d62ae0bd61fc881e23b905b7c987cedf16f51c36224b798964c76b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b2da7831031681b0680295073a382e0306cd8c4a3feac0d81b22b34e05b8fe"
    sha256 cellar: :any_skip_relocation, ventura:        "55b2da7831031681b0680295073a382e0306cd8c4a3feac0d81b22b34e05b8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "55b2da7831031681b0680295073a382e0306cd8c4a3feac0d81b22b34e05b8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94fb1a2d402c31465879b6f5d04434a633f1a5b4b02edc0f17784c453bd7b71d"
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
