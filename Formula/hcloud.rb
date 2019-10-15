class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.13.0.tar.gz"
  sha256 "d1baa87a867091a24d8c56279306df585664296ee20743bc74a73c3a94cdc300"

  bottle do
    cellar :any_skip_relocation
    sha256 "45162c76dbf09c5ccf2d8be86382b5c1c81d90740b1b42b3d4ef4e0cb8a421d1" => :catalina
    sha256 "b8764566dac04685b2ce9490675d9a2adfbf5f00de7c64530fe49d50a27bbf24" => :mojave
    sha256 "2b265e0797a6b7d5c759a8805d739824170962ba99b497ecf84359deaee7af3d" => :high_sierra
    sha256 "31f469cdff808e4b189588018a89873a75fee373d4d6be97bd3b46a0c467ef60" => :sierra
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
