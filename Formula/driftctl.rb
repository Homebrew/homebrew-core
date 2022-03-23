class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.25.0.tar.gz"
  sha256 "b8b9230616db1c594a61bad87c47a602aa28afff4751ec5f2d7d20dd2dad3b78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86f79fbc97660c3461f40e3d4a8fd0ff6c0ba73dce04998bf9d38696e47b7a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a86f79fbc97660c3461f40e3d4a8fd0ff6c0ba73dce04998bf9d38696e47b7a7"
    sha256 cellar: :any_skip_relocation, monterey:       "1f825c045d20ce40a8c10e9e7f95a7986b5ab6f2ad266c1d549fbb9995147a50"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f825c045d20ce40a8c10e9e7f95a7986b5ab6f2ad266c1d549fbb9995147a50"
    sha256 cellar: :any_skip_relocation, catalina:       "1f825c045d20ce40a8c10e9e7f95a7986b5ab6f2ad266c1d549fbb9995147a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea2905671e19a2cceda850802e1f7c6ffe11ed81eb7fc7073228c0a5b6a695b"
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
