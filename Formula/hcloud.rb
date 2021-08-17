class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.28.0.tar.gz"
  sha256 "1e12d771d44b3c25c2b6d96a56465cd3712ec557f5059bad59741108f48f8b3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34ec474173465fff5307f6b8919f9d49972dc6bf978c66cfde28d63f46df63fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c81f49dfb56f049367a7b2cf4caa682d30cd98ad09ac83d54b060b8ddaa4028"
    sha256 cellar: :any_skip_relocation, catalina:      "ccfecdef11aba3b322a17ee99d28af34d8701508c18fcd91d7f4528ad9d70385"
    sha256 cellar: :any_skip_relocation, mojave:        "6164f908222f6b9a5f62617e0d85b37fe4bdc3525472fa29c9d79401b123f9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1424a66e44c0124f9c3f60b5e51d11d522ec6f650d029db0cf01da41fb80965"
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
