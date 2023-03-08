class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.481",
      revision: "abb8b6b1912140679142451616150a36184e4839"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cead76b85f614988cbee62f08a1e597c0b7806dcb32f262a1ff24023791db87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cead76b85f614988cbee62f08a1e597c0b7806dcb32f262a1ff24023791db87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cead76b85f614988cbee62f08a1e597c0b7806dcb32f262a1ff24023791db87"
    sha256 cellar: :any_skip_relocation, ventura:        "fc588e461144464e078fad8d670de71247454a99a5ca5a27755290da7bac9b23"
    sha256 cellar: :any_skip_relocation, monterey:       "fc588e461144464e078fad8d670de71247454a99a5ca5a27755290da7bac9b23"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc588e461144464e078fad8d670de71247454a99a5ca5a27755290da7bac9b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6718338fa6beea76ca3b78c81d84a9185c00b051beda2d8e56e69ca4cb0abfad"
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
