class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.110",
      revision: "6e05067148b9a9ad7e1a7814a69668f265a2ea8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d2f60ceb827ab3ca996d9e18936971d095802faa67e215063a17e052a47a0e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d2f60ceb827ab3ca996d9e18936971d095802faa67e215063a17e052a47a0e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d2f60ceb827ab3ca996d9e18936971d095802faa67e215063a17e052a47a0e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "17753a7243d0b523904bed6ead292be288b39bfbe526e7796452bf5f8c0e633a"
    sha256 cellar: :any_skip_relocation, ventura:        "17753a7243d0b523904bed6ead292be288b39bfbe526e7796452bf5f8c0e633a"
    sha256 cellar: :any_skip_relocation, monterey:       "17753a7243d0b523904bed6ead292be288b39bfbe526e7796452bf5f8c0e633a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6298f6343c4b5e0a61c45e3602c5aca72696c8151669c515e2bccb6bc864e32"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
