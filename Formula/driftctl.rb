class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.7.1.tar.gz"
  sha256 "f22a178eac80ec515712f660e839002225fe836aa129c3505117124e6ee01f52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3e1149bf29e9d0c166008614284792999923eaa28784f5c7b65c9df5103bdb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "7577a4120aa43dadadcc973b5fe17825e89199dc9d86e83fd0d81b35a748c685"
    sha256 cellar: :any_skip_relocation, catalina:      "a3da299d167b148cf52ccec98eb0826dfdc87c32c2bbc6fc129b2c7f0257ce5b"
    sha256 cellar: :any_skip_relocation, mojave:        "b61798625c193ec39740f7b7f5c26d83b9c6594ee62a784992f74e0ff0788952"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
    ].join(" ")

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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
