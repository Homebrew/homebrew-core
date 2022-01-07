class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.18.4.tar.gz"
  sha256 "92296a1fb7c4ce7a8c92a4396e6f6b0341e2b409f224ef816aee9f6193a1dbb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ac7f71da9da259a80bdc90c10db23af38ecfb89acdba0c9f60ab1617b9c091c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac7f71da9da259a80bdc90c10db23af38ecfb89acdba0c9f60ab1617b9c091c"
    sha256 cellar: :any_skip_relocation, monterey:       "66fd35801a66e8356f12d50614d5cb4660e23bff8abe9c55d9065c485aa47419"
    sha256 cellar: :any_skip_relocation, big_sur:        "66fd35801a66e8356f12d50614d5cb4660e23bff8abe9c55d9065c485aa47419"
    sha256 cellar: :any_skip_relocation, catalina:       "66fd35801a66e8356f12d50614d5cb4660e23bff8abe9c55d9065c485aa47419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5deae7dbea92436394fb293523a85b2b8f431c8deb86a0488f5b00baa92c50"
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
