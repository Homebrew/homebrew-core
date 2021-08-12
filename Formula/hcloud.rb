class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.26.1.tar.gz"
  sha256 "ba7fed423b2c437adfb4b98b2fdadaad6b6325f8e31cac2729982b7bf2523c81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "69e40e595e89768282c016c5ad2826af8dc2b9397a0a3d55b78ee2fc63c39207"
    sha256 cellar: :any_skip_relocation, big_sur:       "27687ea61f1875970c09a544f405e4eb87a205371579a3330c32cad212ea5694"
    sha256 cellar: :any_skip_relocation, catalina:      "5a99939fce96cf08aaa031967cfdb587ce75079f4664e8047d5cf17b9808f19a"
    sha256 cellar: :any_skip_relocation, mojave:        "6dd60f434054a649026ed738939ba355be94b96e7ba713fc33f35e00b3fa1d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dc8691e48f50fb27052ab42ee8830724ae48f59fa58807fd43aaec9c5847635"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/hcloud"

    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read("#{bin}/hcloud", "completion", "zsh")
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
