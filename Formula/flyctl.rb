class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.393",
      revision: "b792bf9ca68c4c03b0700afe6f7943960d3c4a99"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2ca11203c12c629ab72d5be51757ea1456481128e29a9958bc176105207adc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2ca11203c12c629ab72d5be51757ea1456481128e29a9958bc176105207adc6"
    sha256 cellar: :any_skip_relocation, monterey:       "683c6a9bdc700415b13e3c5e1ac2c40a17b633c358405a09b5e399b63c5e317e"
    sha256 cellar: :any_skip_relocation, big_sur:        "683c6a9bdc700415b13e3c5e1ac2c40a17b633c358405a09b5e399b63c5e317e"
    sha256 cellar: :any_skip_relocation, catalina:       "683c6a9bdc700415b13e3c5e1ac2c40a17b633c358405a09b5e399b63c5e317e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "558749a21936111d5c1a6d353537c72f5cb1cab00243cce2be51ad2a22be8dfb"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
