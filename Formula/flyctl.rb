class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.402",
      revision: "698f3bda500015354773a2544c90f0b2a6b5ca3a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2fc4033a211860885b976345e72e6ee41d80cbaf1dbc8920e38b24eba1304d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2fc4033a211860885b976345e72e6ee41d80cbaf1dbc8920e38b24eba1304d6"
    sha256 cellar: :any_skip_relocation, monterey:       "4e01ae8577305b27a709b7236bc1af7b7c2dbc8c462db7036d4eaadd17731b1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e01ae8577305b27a709b7236bc1af7b7c2dbc8c462db7036d4eaadd17731b1f"
    sha256 cellar: :any_skip_relocation, catalina:       "4e01ae8577305b27a709b7236bc1af7b7c2dbc8c462db7036d4eaadd17731b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbd1f101712e02f3393e869b9d2406d86ef965d97d1f712ac2f721f3a25e11b6"
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

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
