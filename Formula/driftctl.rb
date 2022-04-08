class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.27.0.tar.gz"
  sha256 "681147c19dbb737c6134b5f1534946b21f6d43b9cf32e9ec444737faa1e25a5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20bd618a5d54cefee1403eea6ca50bc9eaff4c3445169951a2abbfcf5db1b41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20bd618a5d54cefee1403eea6ca50bc9eaff4c3445169951a2abbfcf5db1b41"
    sha256 cellar: :any_skip_relocation, monterey:       "927ab21c3aee7da197f17a6fdb14c12ae2886531b13e13921bce6bba86655630"
    sha256 cellar: :any_skip_relocation, big_sur:        "927ab21c3aee7da197f17a6fdb14c12ae2886531b13e13921bce6bba86655630"
    sha256 cellar: :any_skip_relocation, catalina:       "927ab21c3aee7da197f17a6fdb14c12ae2886531b13e13921bce6bba86655630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6417b7bda26e7043f8724e7b5e40b4c80ad2e61006f8e55eea654cf866085a"
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
