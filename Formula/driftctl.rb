class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.37.0.tar.gz"
  sha256 "6eb05e26edd1d53182e58ae1ed7b5231bf2fb05f5b7b04ab4be39e38461b965f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d21e8c83225a0ffff6f6c9728267fe6eb3eb7ece92d66464c3f3c572608daf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d21e8c83225a0ffff6f6c9728267fe6eb3eb7ece92d66464c3f3c572608daf0"
    sha256 cellar: :any_skip_relocation, monterey:       "94da93082ff8911c56a911ae2da35566f517d0bdc6d9f6fcb4ccfa5d39f070e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "94da93082ff8911c56a911ae2da35566f517d0bdc6d9f6fcb4ccfa5d39f070e1"
    sha256 cellar: :any_skip_relocation, catalina:       "94da93082ff8911c56a911ae2da35566f517d0bdc6d9f6fcb4ccfa5d39f070e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88617b8800a8523981d6de4b183f68c625e34d9390c4e36f1f036f95c02107ba"
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
