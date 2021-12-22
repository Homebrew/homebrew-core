class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.18.3.tar.gz"
  sha256 "0e1bf0981ffa39c531dfcd2422ea865c302c8985ac4b5c846ecb62b468456701"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519ada904020654fb9604072f74f76c5f224f6f13df107c035ca1d8a653fb6ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "519ada904020654fb9604072f74f76c5f224f6f13df107c035ca1d8a653fb6ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b8710c3f523d91c8d7a4f49ffaa27692abd11d274d79ba3cea27a507988477d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8710c3f523d91c8d7a4f49ffaa27692abd11d274d79ba3cea27a507988477d1"
    sha256 cellar: :any_skip_relocation, catalina:       "b8710c3f523d91c8d7a4f49ffaa27692abd11d274d79ba3cea27a507988477d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae52115017495dc9a069e0f358483e73f1acdace105971569ad79674607c7e5b"
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
