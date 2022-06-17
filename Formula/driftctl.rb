class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.34.0.tar.gz"
  sha256 "b8b75d0756f7e703a6bc3ad2c44de75f03402854eff28f0752a9eca80691c186"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a017a6fa26b406e8c0e6a39224e4ebaf6b179b5533c873424b12e0dccd2c9f3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a017a6fa26b406e8c0e6a39224e4ebaf6b179b5533c873424b12e0dccd2c9f3c"
    sha256 cellar: :any_skip_relocation, monterey:       "393e0801fe0a9366a7aed72d585164480938355b771e9b1b309c14289a865259"
    sha256 cellar: :any_skip_relocation, big_sur:        "393e0801fe0a9366a7aed72d585164480938355b771e9b1b309c14289a865259"
    sha256 cellar: :any_skip_relocation, catalina:       "393e0801fe0a9366a7aed72d585164480938355b771e9b1b309c14289a865259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff5337bfd89a7fc56e95c6d4265b095c579d4c69da5265a05fccafebe6e2a1e"
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
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
