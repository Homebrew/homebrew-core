class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.26.0.tar.gz"
  sha256 "e6fa40c2cb407e05b48de9ed697e14ad7bca9557274543a1c5d1ff592c4237c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f89f0fdb42c9ade64b068d5b24938bb481decc0c868d5dadca12a23abdc4fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f89f0fdb42c9ade64b068d5b24938bb481decc0c868d5dadca12a23abdc4fb"
    sha256 cellar: :any_skip_relocation, monterey:       "9574deec4050bf164e78eb76892582d09724315401414d1a561df9066e113b89"
    sha256 cellar: :any_skip_relocation, big_sur:        "9574deec4050bf164e78eb76892582d09724315401414d1a561df9066e113b89"
    sha256 cellar: :any_skip_relocation, catalina:       "9574deec4050bf164e78eb76892582d09724315401414d1a561df9066e113b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4f0b3da6dcdae95828487c5e72846449adeb95f69a5d52f3a4cd7f95e43495"
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
