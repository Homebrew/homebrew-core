class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.6.0.tar.gz"
  sha256 "8ada1db53f812774666d579722bce1d63cfd0212a70dd0d3ca734608610584b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e6544240e92a21300cc223460e9ca72f25371c9ff9d4ebef5a102e3d7c16182" => :mojave
    sha256 "0c710c7c12c15a186411ccf4e919227f6615557400f127f51ddbb1aed2f6110b" => :high_sierra
    sha256 "91fbe41966cd0e151a79eaa0440e07f7baec9557bb870e6457a35694ddace58e" => :sierra
    sha256 "907f1daf1241855d5007bad92f8401521d2a0d1a8c7bf883e39777f4a6236d8f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
