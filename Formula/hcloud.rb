class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.20.0.tar.gz"
  sha256 "116089f671f3f484b45fa8264cd016f92246421ba8c444a98d5bc18741e625e5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7c10f79205f3e38247cb40db50a81f5dcba875be47e34ab42871e8dc4f43eee9" => :big_sur
    sha256 "bc0060e4db541d77ab09fea18eefbb3711ba806efa944ed44186c0c5330d3f08" => :arm64_big_sur
    sha256 "365e9535a762a7be3ab78d2ea33e9ba3444311805bfadec8c81f79e702211348" => :catalina
    sha256 "99878daa16a1aa6b393292bc874faf9d6f7071d18cfb0383081c3a33f867a326" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/cli.Version=v#{version}"
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
