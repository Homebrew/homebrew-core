class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.16.1.tar.gz"
  sha256 "582e0ad9b4d01e688adb7ab8f680984bd481861eb3f23797dcaa581e41665827"

  bottle do
    cellar :any_skip_relocation
    sha256 "95227213fe49fa0afc8f64c38a23b664799a4154dbb4535e96e2d881474a3ec2" => :catalina
    sha256 "6d28279289f5f512185ff6fa4421d11d26fecb8f81c21047e6e5dbc97fa1e8fe" => :mojave
    sha256 "80247d5aeec5b4b79b5ecc88b384eb2ffce80347cd0954581f5f9f7334fa899b" => :high_sierra
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
