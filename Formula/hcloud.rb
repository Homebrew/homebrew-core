class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.24.0.tar.gz"
  sha256 "2a5db962b6a5fdd57beb31c5fe0b1202f0dc6f508aea93151148586040cbb975"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c80badbb82f0701f97612f688184c3fcc8b13433eb75083c6d1188fbaae9845c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b6142d37875ed2283e682c471bbd298d2be104069ff40e7192685b2e8fef354"
    sha256 cellar: :any_skip_relocation, catalina:      "00137c5bda7c47373829c3fdc28d1964863bc41bc82964465711bb9f70eeea60"
    sha256 cellar: :any_skip_relocation, mojave:        "a0d55ec31e314b04035c2108dc84a57eacbb1ef6f3f4381feca3f608831ddc86"
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
