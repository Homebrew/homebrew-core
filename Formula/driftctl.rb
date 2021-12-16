class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.18.1.tar.gz"
  sha256 "6a75838f31ec24d9b53e075d2edc21c5944f45a534588b809f5121a4c8bfb21f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f614ebddab26fc5e705f5255df1518e5179ae47d5ce0ee285c3b720026c28bdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f614ebddab26fc5e705f5255df1518e5179ae47d5ce0ee285c3b720026c28bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "4f4162df486ebbc4ecd50d9f9a4e20dee7c5f006adf1099be53cf07f002a54bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f4162df486ebbc4ecd50d9f9a4e20dee7c5f006adf1099be53cf07f002a54bb"
    sha256 cellar: :any_skip_relocation, catalina:       "4f4162df486ebbc4ecd50d9f9a4e20dee7c5f006adf1099be53cf07f002a54bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b56ea96b17258f97ccb36e1ab34e96f08053d6d77262611eb824ceb4a273cb"
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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
