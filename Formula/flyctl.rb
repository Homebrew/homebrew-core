class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.313",
      revision: "13e33505653977110a8a7021ac0bafc90bb40556"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b38e2d7507e3478c8690fd99ba566acc630fdc427b7679f790dca4ac9a28b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b38e2d7507e3478c8690fd99ba566acc630fdc427b7679f790dca4ac9a28b1"
    sha256 cellar: :any_skip_relocation, monterey:       "56cb74d24b61315054be954b06d44404c91e31f2d8634701d5118ad1a76c1d66"
    sha256 cellar: :any_skip_relocation, big_sur:        "56cb74d24b61315054be954b06d44404c91e31f2d8634701d5118ad1a76c1d66"
    sha256 cellar: :any_skip_relocation, catalina:       "56cb74d24b61315054be954b06d44404c91e31f2d8634701d5118ad1a76c1d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be845f325d090dd6b84f09c4ee8f2fd06246f8af3993b8472cd14b29994bb099"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
