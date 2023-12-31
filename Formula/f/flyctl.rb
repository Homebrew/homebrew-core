class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.135",
      revision: "4cd282a8ce995bec8fb408d880f159159eb209bc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "553d473274f4ffd6fad133b44475061f460ebca111b6d9ac5a4de46ab9c9a03f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "553d473274f4ffd6fad133b44475061f460ebca111b6d9ac5a4de46ab9c9a03f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553d473274f4ffd6fad133b44475061f460ebca111b6d9ac5a4de46ab9c9a03f"
    sha256 cellar: :any_skip_relocation, sonoma:         "02f8899f6ab2bbf66e44958d4a58e9518461a6117131a3f24093d727d17e8d7d"
    sha256 cellar: :any_skip_relocation, ventura:        "02f8899f6ab2bbf66e44958d4a58e9518461a6117131a3f24093d727d17e8d7d"
    sha256 cellar: :any_skip_relocation, monterey:       "02f8899f6ab2bbf66e44958d4a58e9518461a6117131a3f24093d727d17e8d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8596d636bc63137c9262ea890e6a8f1ec9e2b054e6b1c33fbbac228301d416"
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
