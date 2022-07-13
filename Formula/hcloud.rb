class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.1.tar.gz"
  sha256 "6530f5b2e90fbc74ea7b91da283840d08138b361166fc0eba3e9723313a712d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50bd208ad9cf384c88dec2af9d80172e64c1d57c2f642a3df4c06ef7f6175ebe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f82a5f22e6a4346875e91bc665065575a21873babea74397aa83e436cbdf9975"
    sha256 cellar: :any_skip_relocation, monterey:       "416b0125eea72972787840cf62ced7b5bfbd44da7afb70988ff5384a7d1b2fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0924326dec4e74c3f64bea5b63c618a45bb7656333b84e37b79e83599582872"
    sha256 cellar: :any_skip_relocation, catalina:       "852d93d17c58988e958788433994371f3f3e8ad22415d335041361b3c6943ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8072aefa3799d2a142c6f47d537eddab7e161511429422f80478359b14bf2c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    output = Utils.safe_popen_read(bin/"hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "fish")
    (fish_completion/"hcloud.fish").write output
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
