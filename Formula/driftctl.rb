class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.18.5.tar.gz"
  sha256 "9306553499c649e76abe3647986a20e69832e050d1e6bb5150d144cf61b07db3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47ef2daf284042249af8df5c05006eda9d6cea46f8b7a9d2ad10daa182c89ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c47ef2daf284042249af8df5c05006eda9d6cea46f8b7a9d2ad10daa182c89ec"
    sha256 cellar: :any_skip_relocation, monterey:       "7d19582be4027ecab5a2cd2492363f0d7591a78ff444f4d5b1f1a9306abc973c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d19582be4027ecab5a2cd2492363f0d7591a78ff444f4d5b1f1a9306abc973c"
    sha256 cellar: :any_skip_relocation, catalina:       "7d19582be4027ecab5a2cd2492363f0d7591a78ff444f4d5b1f1a9306abc973c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292bc3ba9f1dcf03ca4252147ae984318382fba5976656892ab3d1ebfcdeed97"
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
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
