class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.16.0.tar.gz"
  sha256 "eceaf25868706751392afc8cd1bef58a374f49437911335924ef1a27845f5a9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b2cf46eea63f889ba9f00bbdf223e26fc59dc389278c79fe86c986c1f3728de" => :catalina
    sha256 "64b3f9d2d1c4e098a29f23c083e59046a6eb9d082b9733fa32987e5f6492dabd" => :mojave
    sha256 "81cf03ed34c26493b87b2f6bc3a1c82acb2e62d0f8a34cadc8ab6b0437532483" => :high_sierra
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
