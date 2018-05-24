class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.5.0.tar.gz"
  sha256 "cc09f03c6a776a086ee9219e9ee70749e2ef5cda6171dd042cb1c623cccd6dfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddea77b0be1a2db8b70f025af9f523cfa7946abd5ce0e90b09b708cc13a6d8a9" => :high_sierra
    sha256 "99817f51fc23573db89892437513725680b1d4df700c2eb27143d852c344d24b" => :sierra
    sha256 "e348f096f1cd562bc30f740fb655fc3e42b619e2175e3dcb829130a15decf85f" => :el_capitan
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
