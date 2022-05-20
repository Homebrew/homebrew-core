class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.30.0.tar.gz"
  sha256 "ee38f4d642e7b3de1aff92f310137f1abc39ffe133a5580d5826b392698b1aaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1fae2d0b6a23b68ab1e718474d148ed6f5f7adf54cf14347ab887b7ba0df71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c1fae2d0b6a23b68ab1e718474d148ed6f5f7adf54cf14347ab887b7ba0df71"
    sha256 cellar: :any_skip_relocation, monterey:       "ef0e3f4b8fa6058ae982f4ff959d983c69930503bb45efb332e77924f85608c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef0e3f4b8fa6058ae982f4ff959d983c69930503bb45efb332e77924f85608c2"
    sha256 cellar: :any_skip_relocation, catalina:       "ef0e3f4b8fa6058ae982f4ff959d983c69930503bb45efb332e77924f85608c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4d09aed230605b815297d4fcb94ca154917b64422d72f19bd584a67477e365"
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
