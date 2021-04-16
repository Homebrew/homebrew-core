class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.22.1.tar.gz"
  sha256 "6b43ad74ec243484c7c1dd1d7cb2d6f1231f596a2ea4753bf81087f5b8dcf1c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c8e315a58d21374412be369cffe0cf104d1864e488a983a60c8db6e234b4f9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c22020100fc461eaeae0feaefb4b89ecb3fd8f6eb9aa7823528dcbc9578f79ae"
    sha256 cellar: :any_skip_relocation, catalina:      "ad8daca1f04d1a59480bfae18621caa823c934051775fbf562da9f3bcfcdcfea"
    sha256 cellar: :any_skip_relocation, mojave:        "d9d53c9aebd2b2494ada13b04d51b9bc23365547aebcdb8bff2f5439bb517321"
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
