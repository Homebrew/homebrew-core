class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.87",
      revision: "499c43286ab82c5ef5b56bff2823fadb387f78f3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f85d209777829ca75c94f5e5fe06852aa188e963b09fbef088576aab7ae42d04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f85d209777829ca75c94f5e5fe06852aa188e963b09fbef088576aab7ae42d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f85d209777829ca75c94f5e5fe06852aa188e963b09fbef088576aab7ae42d04"
    sha256 cellar: :any_skip_relocation, ventura:        "300d382108ed349ebecb6935d8c817c4e5956dba746710e0910cd63a946e0cad"
    sha256 cellar: :any_skip_relocation, monterey:       "300d382108ed349ebecb6935d8c817c4e5956dba746710e0910cd63a946e0cad"
    sha256 cellar: :any_skip_relocation, big_sur:        "300d382108ed349ebecb6935d8c817c4e5956dba746710e0910cd63a946e0cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bbf03d7d4e580a30087b955bd902d5b921ea2b41e834f96dd2096febb36898b"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
