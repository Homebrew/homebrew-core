class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.499",
      revision: "10c95df6dd1203ad8161a1f85e198be40f0e6c9b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6920d935cc5bf694450cf5e799c9a7a573c1fe92781a92ea70e567be2606120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6920d935cc5bf694450cf5e799c9a7a573c1fe92781a92ea70e567be2606120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6920d935cc5bf694450cf5e799c9a7a573c1fe92781a92ea70e567be2606120"
    sha256 cellar: :any_skip_relocation, ventura:        "b367a17ccbbf3e518599e851cc95912dd040c3aec83e5859ba41c9ca960a6286"
    sha256 cellar: :any_skip_relocation, monterey:       "b367a17ccbbf3e518599e851cc95912dd040c3aec83e5859ba41c9ca960a6286"
    sha256 cellar: :any_skip_relocation, big_sur:        "b367a17ccbbf3e518599e851cc95912dd040c3aec83e5859ba41c9ca960a6286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eceb8835343b7cb87e44437154d1d921fb86487e05c8b8ed880da9beb8de6d47"
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
