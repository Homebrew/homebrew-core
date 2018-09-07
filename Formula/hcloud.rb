class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.7.0.tar.gz"
  sha256 "e48ca7f56ba8ffb70c1a14d1c20552f54c9b224f96b42d95230974fd63625838"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb4393eb1708f2e73161fbf424a08ee4964dc684c9fd3508271112976a44e014" => :mojave
    sha256 "43815538078107706a98f2954d4ebcce062f0498af92eb170c2baf162495b448" => :high_sierra
    sha256 "53fe4e5ba7f8c37b739f7f77c3e776c7ad5f70eb9259b9740b356b234bc067f7" => :sierra
    sha256 "41ed36b25e27d88fd7c433c09da1a65430b78e857ec72e0dbcf1d5d0eb5874d8" => :el_capitan
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
