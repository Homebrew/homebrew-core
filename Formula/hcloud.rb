class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.26.0.tar.gz"
  sha256 "e00966e8020fe06157e55cf48e2c98bc9ffd77fb24e07405b7f87bce24eea4b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efb93630d989ad7712c2865d26de7075b4eb55b190393c6c3339e9266320060e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e71707d9f66a6475fe25f23b75b7e145f8d8657a0adff02ffa8118a96f09ef95"
    sha256 cellar: :any_skip_relocation, catalina:      "65a9fd8c9a10fc1113a1f8399bb60cf6e3f1ae6732c81f3b46b9bfbfe2eb5941"
    sha256 cellar: :any_skip_relocation, mojave:        "2f6912bd56e8354f5c2446de3ae6ef3f1ad7ae1ccf71c616a987bc5799a2c80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de748f0e422b6edb1fd698169ded93891ae88a6a621baa8093c7c579afcb1c0e"
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
