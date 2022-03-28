class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.309",
      revision: "7f90ae39733a7f85ea79b5607f4716596c7316ee"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2373205aceb730b70e3d60581fc12538384027e601f9c8d87b89e09bbc46ad41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2373205aceb730b70e3d60581fc12538384027e601f9c8d87b89e09bbc46ad41"
    sha256 cellar: :any_skip_relocation, monterey:       "ab95cf5f428a113f06050be58bb60a9429475236424c61990ddc8e7d3fe05136"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab95cf5f428a113f06050be58bb60a9429475236424c61990ddc8e7d3fe05136"
    sha256 cellar: :any_skip_relocation, catalina:       "ab95cf5f428a113f06050be58bb60a9429475236424c61990ddc8e7d3fe05136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b82a08e288dc86eacc280c9d049a0c286894e072eb2ec727e55f8fa7be8a04"
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

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
