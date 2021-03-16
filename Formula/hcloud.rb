class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.21.0.tar.gz"
  sha256 "1e99850ebf46b2c12bc90007fded6538582c9d7c9102bef556acfadf07b652ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e979c538e706e84e25148794aa1970498cbf2aed180940331ba86f2f6f710cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "69ab4535cc08cc2782a1b47c87870636feb74968c7ff08e7f53004edff98c4cc"
    sha256 cellar: :any_skip_relocation, catalina:      "bcef1926ff4ad60929385b105623dfa243a5e6dfa0f0c7771e9b86f7c39a9373"
    sha256 cellar: :any_skip_relocation, mojave:        "638d494051cca42ec0368c33b298995f7fa347a56bf69dc01321434cafad4ac9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/hcloud"

    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
