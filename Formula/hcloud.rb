class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.5.0.tar.gz"
  sha256 "cc09f03c6a776a086ee9219e9ee70749e2ef5cda6171dd042cb1c623cccd6dfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "5deffd6efe224636362ba5e995df57b3c4ec85065c15f8a55261608a7e590501" => :high_sierra
    sha256 "72a32be135be4719a5ec50c1bb8762d1c3648c7f6a5a814b234b2d69c7341300" => :sierra
    sha256 "eb41b7bd5cc58860c20b4d7e06d93e4d2d9ec7fac6bc070c2e401a488098a3a8" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hetznercloud/cli").install buildpath.children

    cd "src/github.com/hetznercloud/cli" do
      ldflags = "-w -X github.com/hetznercloud/cli.Version=v#{version}"
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
  end
end
