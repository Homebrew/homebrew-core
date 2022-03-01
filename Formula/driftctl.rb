class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.22.0.tar.gz"
  sha256 "6790d29b0ce71da30b1a9b5e247623f5eefd19ce55a634adf988b933a3b7e7b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa1ef3f46494eb76084c26e297ae44911d0644a74c0cbc6a0c88dfe49748651e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1ef3f46494eb76084c26e297ae44911d0644a74c0cbc6a0c88dfe49748651e"
    sha256 cellar: :any_skip_relocation, monterey:       "e988e7b7539074dfdd4eeaa1994df6de78d7133998785af81da3228af4d22c5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e988e7b7539074dfdd4eeaa1994df6de78d7133998785af81da3228af4d22c5b"
    sha256 cellar: :any_skip_relocation, catalina:       "e988e7b7539074dfdd4eeaa1994df6de78d7133998785af81da3228af4d22c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c905a99de27aa75433661ba03536e4ba502b2e62c6e39ea71c9358d3e8d0bd1f"
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
