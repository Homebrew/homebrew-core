class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.8.0.tar.gz"
  sha256 "3745561c43816a8d01f8c4a8ec5d64de3d5da1501537425813ccf294e64b38ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "b73701022c22c3c884677a39ec93cffb071ba712f48f53cf705d92b649d2ad2e" => :mojave
    sha256 "6b328834a8e30a7741c5c927a55b2fdbd6ccedb58ade9c9ca36ffd4ae4ce98a5" => :high_sierra
    sha256 "efa71d4f60df23efadf229a848c9ceca9d6e338b6db7737b0a650774e043fb81" => :sierra
    sha256 "a40c819c6b02499195e28db85664962404165acfbdb8a26816c88b05db87c28b" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/hetznercloud/cli").install buildpath.children

    cd "src/github.com/hetznercloud/cli" do
      ldflags = "-w -X github.com/hetznercloud/cli/cli.Version=v#{version}"
      system "go", "build", "-o", bin/"hcloud", "-ldflags", ldflags,
                   "./cmd/hcloud"
      prefix.install_metafiles
    end

    output = Utils.popen_read("#{bin}/hcloud completion bash")
    (bash_completion/"hcloud").write output
    output = Utils.popen_read("#{bin}/hcloud completion zsh")
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
