class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.348",
      revision: "c761ede3f773cc7a3595dbdf0804321eab05e66e"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2252e8316c4da7062948b4a8b4027d6bb2fc7c9f6da123eb45994234bb0bc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2252e8316c4da7062948b4a8b4027d6bb2fc7c9f6da123eb45994234bb0bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "44904a693945e52b10b5595a6387b3dab58eea2469ca31af80c5c78cbbb45c3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "44904a693945e52b10b5595a6387b3dab58eea2469ca31af80c5c78cbbb45c3c"
    sha256 cellar: :any_skip_relocation, catalina:       "44904a693945e52b10b5595a6387b3dab58eea2469ca31af80c5c78cbbb45c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9968dae03f2172b90c568f0fbe992aef7479cb364b9242b279f88180fd740dae"
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
