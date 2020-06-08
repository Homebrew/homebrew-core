class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.16.2.tar.gz"
  sha256 "15b19b671cebda5d9ec1bb1fce7286515b97d3b0256775f9943f76a4c257f331"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb706c1cfbc249a8b1cdf8c2c7c3f92d2efd50a575fc0342fe2d03b99ecd7f4c" => :catalina
    sha256 "bf1d8f2851ddac88a1be71bb5018ae3cbce46747f6d302c3a95f755b23518301" => :mojave
    sha256 "e3866d38a3fa70ddf5a43876802fa6e227ece4ab5c64457c61ce716d09daabf5" => :high_sierra
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

    output = Utils.safe_popen_read("#{bin}/hcloud completion bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read("#{bin}/hcloud completion zsh")
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
