class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.387",
      revision: "d46c14f3ab0215de43098f1d40aa5279d85b5d5b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38172c2b600fcde3f7623e380e042e2d9b656d4f0216cf94edf7cb28b6c5ff89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38172c2b600fcde3f7623e380e042e2d9b656d4f0216cf94edf7cb28b6c5ff89"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0091475baaaaea5255ea212cb2f8d349c66b9244f0ef82cfe3ff5aa123c21c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d0091475baaaaea5255ea212cb2f8d349c66b9244f0ef82cfe3ff5aa123c21c"
    sha256 cellar: :any_skip_relocation, catalina:       "8d0091475baaaaea5255ea212cb2f8d349c66b9244f0ef82cfe3ff5aa123c21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51405ecc9b6f76e71e2025511334112d971391401a049bd32b16151dd8466f0d"
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
