class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.35.1.tar.gz"
  sha256 "16328b78687770a80efe455a6ceb4bed6a18b82968d86c0aabfbd1f3ee5b6a64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5441f831bf2c3a45c61f937ff996effefb1fc4cd3251f8af0029d8b53cd0172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5441f831bf2c3a45c61f937ff996effefb1fc4cd3251f8af0029d8b53cd0172"
    sha256 cellar: :any_skip_relocation, monterey:       "3c63e810d3fc0ab7a419a1568b09f31508c1dc9a7920be6fe0b942028d7cf256"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c63e810d3fc0ab7a419a1568b09f31508c1dc9a7920be6fe0b942028d7cf256"
    sha256 cellar: :any_skip_relocation, catalina:       "3c63e810d3fc0ab7a419a1568b09f31508c1dc9a7920be6fe0b942028d7cf256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5828f88409066a679a96e229c73a00325a2aa371917c3035ad5154fe6b81fc5"
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
