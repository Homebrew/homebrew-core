class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.332",
      revision: "4d3bed4271f8a7abbdfd4b859c90e678cf06a12d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb9f2c566d478a4d03a4ad097e61cc2398556629b88fc55d57cdc7647228167"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feb9f2c566d478a4d03a4ad097e61cc2398556629b88fc55d57cdc7647228167"
    sha256 cellar: :any_skip_relocation, monterey:       "60597f35a3f2606d62a57ac6b93814a2f6beab639a41ef817d1e125e4ef81b86"
    sha256 cellar: :any_skip_relocation, big_sur:        "60597f35a3f2606d62a57ac6b93814a2f6beab639a41ef817d1e125e4ef81b86"
    sha256 cellar: :any_skip_relocation, catalina:       "60597f35a3f2606d62a57ac6b93814a2f6beab639a41ef817d1e125e4ef81b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea783510c9e94608edac330de7af2a647268ee4a93d6f1efc38da632fdbe577"
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
