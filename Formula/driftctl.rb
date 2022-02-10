class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.20.0.tar.gz"
  sha256 "5b5d849b558c97e41fb7aaab4a7692fb0d6569fd8e9bca7c8b553f24d3f2fb41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70a59c3162e70071f7242d501d5aac8e1a0f71905c0b81ec0f5c8322d8f1139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e70a59c3162e70071f7242d501d5aac8e1a0f71905c0b81ec0f5c8322d8f1139"
    sha256 cellar: :any_skip_relocation, monterey:       "4a92b5a8dfdfef66a7386bb8c212cdb7eb8bb79879b59c600459af5f69de0d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a92b5a8dfdfef66a7386bb8c212cdb7eb8bb79879b59c600459af5f69de0d9b"
    sha256 cellar: :any_skip_relocation, catalina:       "4a92b5a8dfdfef66a7386bb8c212cdb7eb8bb79879b59c600459af5f69de0d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50b4bf996a805bd8a64d59bf0c9513b5a7ba10dda0606decee7ee24aa1ee7a2"
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
