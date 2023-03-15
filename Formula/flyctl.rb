class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.488",
      revision: "d56b165decfa5b1786dc0a613f77b74e2154c9be"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23c0b453311f0c283b791f2671e30891c3e2a5e129e74fa6522dfc6fb8458bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23c0b453311f0c283b791f2671e30891c3e2a5e129e74fa6522dfc6fb8458bf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23c0b453311f0c283b791f2671e30891c3e2a5e129e74fa6522dfc6fb8458bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "1701c67ba1f4972c300fca9b53bb954aee811ddf0f1d0ec144f560ab89548241"
    sha256 cellar: :any_skip_relocation, monterey:       "1701c67ba1f4972c300fca9b53bb954aee811ddf0f1d0ec144f560ab89548241"
    sha256 cellar: :any_skip_relocation, big_sur:        "1701c67ba1f4972c300fca9b53bb954aee811ddf0f1d0ec144f560ab89548241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27556abcf4a47d4d1e01a4babb2d67ee7085ff0a996bb6fb32d21ee0f2df54bb"
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
