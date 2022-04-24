class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.323",
      revision: "c4d632865c927cf823f6b031a1d465b337490065"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ab935248adadb68cdb1a501829e1ffec6387185c04e0795ee3990dbf5c7cf7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ab935248adadb68cdb1a501829e1ffec6387185c04e0795ee3990dbf5c7cf7e"
    sha256 cellar: :any_skip_relocation, monterey:       "1af2a936485d0f552612a9b5630df382b28f5497164574ef2288275d8179324b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af2a936485d0f552612a9b5630df382b28f5497164574ef2288275d8179324b"
    sha256 cellar: :any_skip_relocation, catalina:       "1af2a936485d0f552612a9b5630df382b28f5497164574ef2288275d8179324b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cab68a88f638befe1645eeb3b79f3fd2204c15e25feaba2742a577855a552d0"
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
