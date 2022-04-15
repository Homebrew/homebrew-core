class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.28.1.tar.gz"
  sha256 "1266e9f65d524346d917f99aa0e61685f84da4691c43453cd87d74a17c76e7d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7de34ae39aa0657d42c81607e9517290b5e7bc2b3a65520ba2a72944532b741"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7de34ae39aa0657d42c81607e9517290b5e7bc2b3a65520ba2a72944532b741"
    sha256 cellar: :any_skip_relocation, monterey:       "0b712266d863ee827f2c105c3cb8c5ab438f124b09720362d4eef0ef01f6225e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b712266d863ee827f2c105c3cb8c5ab438f124b09720362d4eef0ef01f6225e"
    sha256 cellar: :any_skip_relocation, catalina:       "0b712266d863ee827f2c105c3cb8c5ab438f124b09720362d4eef0ef01f6225e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4b2cc8987603f828f4b3e7e44d311fd3818685b9bf98f4eb347959e326fd1f"
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
