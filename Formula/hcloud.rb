class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.24.0.tar.gz"
  sha256 "2a5db962b6a5fdd57beb31c5fe0b1202f0dc6f508aea93151148586040cbb975"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfcd4be30cb1cf354c552b67c426b520a56e54d67955468a789defae22875d55"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c45503344f075ecd8265205e2f4229685231b4ab2b13f20e3d56d1d9110081b"
    sha256 cellar: :any_skip_relocation, catalina:      "0f89d2f3a3ee0eeed4dc456c856e6aac854f7cc4eec4dff3de89c67ac705c64e"
    sha256 cellar: :any_skip_relocation, mojave:        "849520b12d7d442d033657163ef3e04a1afc1dd4b95daaae5c1ff83503d4c070"
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
