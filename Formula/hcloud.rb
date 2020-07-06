class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.17.0.tar.gz"
  sha256 "72710ebf4ce5598791d4e295dc749b7996433084dcd7523ced97912d321bdc4f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2f4380704f5a26b3641ba22eefe76e5727f2d5a896f610690440d53b97a6019f" => :catalina
    sha256 "c8f1899db008f59048dcddcac0768849c089edc27b44a010f23e99f2815acefa" => :mojave
    sha256 "602946c6991d779a617cec60e57f27b28d447f5334f09e9fa6e42c957144a8ee" => :high_sierra
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
