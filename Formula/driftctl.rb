class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.23.0.tar.gz"
  sha256 "fe0c7436a21f483dbd21357482dcf93ba27dce4d12f9cee07154f3acd033c875"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7df43a8a43d4db0be9e01820292554873d1932687a2ac1ff7539b7f08159fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a7df43a8a43d4db0be9e01820292554873d1932687a2ac1ff7539b7f08159fb"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec8f893751a819ed112907ca49edb966fade4e86409c115a4c1bff61c9d1e43"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ec8f893751a819ed112907ca49edb966fade4e86409c115a4c1bff61c9d1e43"
    sha256 cellar: :any_skip_relocation, catalina:       "5ec8f893751a819ed112907ca49edb966fade4e86409c115a4c1bff61c9d1e43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5ff5858cf902938cd6be493458e93e03e7be65d6d81ed4e080846205357f31"
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
