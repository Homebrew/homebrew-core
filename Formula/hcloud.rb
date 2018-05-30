class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.5.0.tar.gz"
  sha256 "cc09f03c6a776a086ee9219e9ee70749e2ef5cda6171dd042cb1c623cccd6dfa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5c6ff02f7c5aa341b3a7cf640e66355a16083cb64a32bee32eec1aeaf0252400" => :high_sierra
    sha256 "a389b4bf39549713809acdcec93ccc8c907c5b56a2817380fcb0946a270e8071" => :sierra
    sha256 "e6fd5b0b4a9db1fb1db687e045c035c8cd552720ec887d7858436d5e2a3bb0bf" => :el_capitan
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
