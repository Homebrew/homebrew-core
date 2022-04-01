class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.29.4.tar.gz"
  sha256 "49dab6fc46e1fa10eb49800df463f6fab413edb62b585ea9474e981d8bf98323"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65e73b6d461b64a512f5d72f9bfb5d71abbee2f915038eadbfde03683c56e714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "896b6d8f451206911d9919ff92c415371e0b47624ed33e0fff7681a858fafca9"
    sha256 cellar: :any_skip_relocation, monterey:       "86953a27658cd605bd63a61b6a41868827cb5de0b3ba638e94728473c31a1579"
    sha256 cellar: :any_skip_relocation, big_sur:        "f992dcc13506c5af3f54387b5d2ecce4678b04b6f95cd7d59742e60011b5981b"
    sha256 cellar: :any_skip_relocation, catalina:       "50f6f109eed783337f403da4399bcf54fe3ba23c1dcd8728454f467227ee4843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5441f014a6f352e26d4023fb730e481fe5131a15f0017d64465798c21bfc4152"
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
