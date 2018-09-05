class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.6.1.tar.gz"
  sha256 "c9aa89fbd2992f1c710c2a81aa72a8f4e0f6cc9ca2b990ace4b01926442753b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "76542229d96bb8b1e6a6f6db5ed1db5b9244a893b0af48868d4923332dc35906" => :mojave
    sha256 "b17b13fc82020fa622c7c4291e6ce73aeb075c8a7038b88100555fc9b1ab0d5b" => :high_sierra
    sha256 "832e16deb1184117962c6e73a50492ded8f52935131557c15df0dc531e08c490" => :sierra
    sha256 "78a211578022faf429a1997a07251a5899f3f6bcd9614ace3faaf4466d6d3082" => :el_capitan
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
