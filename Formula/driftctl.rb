class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.21.0.tar.gz"
  sha256 "5241d428c22689f60b489ae7c40314201a337a87a29b34db7742206c5a95ed4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e0285722918d4cb4912cc08f8211941c75844f238c06f92e8db9f1ce1b5da2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99e0285722918d4cb4912cc08f8211941c75844f238c06f92e8db9f1ce1b5da2"
    sha256 cellar: :any_skip_relocation, monterey:       "b6251b90a9a10b22d86d08a9ba4d0af643e760f8ee166ecf131026198fe465b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6251b90a9a10b22d86d08a9ba4d0af643e760f8ee166ecf131026198fe465b1"
    sha256 cellar: :any_skip_relocation, catalina:       "b6251b90a9a10b22d86d08a9ba4d0af643e760f8ee166ecf131026198fe465b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c1f1c24f1c084d5b4bd5ba9001a694b13deb426addd2e14934ff93431c45aa"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Downloading terraform provider: aws",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
