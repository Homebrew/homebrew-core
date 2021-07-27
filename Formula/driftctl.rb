class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.13.0.tar.gz"
  sha256 "268d93e1c78504fd44b8df22b7c6353564c5423b79bf9e808b7814b255ccf049"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b04a72ff2c7fabe1c3b33f1466d6c9df505287da0a8ab8803422ccfeba50c4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "591cae8d7d294948fde7580c627d160bc60ea0fe009e00a57c25f2a4abdd69b0"
    sha256 cellar: :any_skip_relocation, catalina:      "591cae8d7d294948fde7580c627d160bc60ea0fe009e00a57c25f2a4abdd69b0"
    sha256 cellar: :any_skip_relocation, mojave:        "591cae8d7d294948fde7580c627d160bc60ea0fe009e00a57c25f2a4abdd69b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea13b8c01843422a5624ac589c7b7070579854e97602d0b5b50612bb649bc5f"
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
