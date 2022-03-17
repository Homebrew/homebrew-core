class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.23.2.tar.gz"
  sha256 "312f8c9ec1265be8e5d86193992d4467eb8798e809fc30376f847f28829316dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2ac4d5c8305cd406d22ac1ec7221d6bf883221c8ba70c13b5cdda08e461f4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe2ac4d5c8305cd406d22ac1ec7221d6bf883221c8ba70c13b5cdda08e461f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "3b01f5db54f76573584673736d34de8a164b55deff78dd4e88f9201b3cb5025b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b01f5db54f76573584673736d34de8a164b55deff78dd4e88f9201b3cb5025b"
    sha256 cellar: :any_skip_relocation, catalina:       "3b01f5db54f76573584673736d34de8a164b55deff78dd4e88f9201b3cb5025b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bdd2d91a763ada6fb5ca58615b4890f2b4b6e9bce9244b8d96628ffd3f1b6e0"
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
