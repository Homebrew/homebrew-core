class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.0.tar.gz"
  sha256 "12110363deb3d4bb66f4ab0350b3ee220c38d9f9a4bda94bb8396c32c9025e33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250b63879cde52e657a738f978a1766714b30c78580c7112de7523dc32073311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffdac50445bff8c904564c7cfb1e7d8c9da5c66ad7a52ba960c33c1bdbb0fa7c"
    sha256 cellar: :any_skip_relocation, monterey:       "9595dea61370a7b75a69795160147ce236d0b9d5e309a7579b209f2c2454d736"
    sha256 cellar: :any_skip_relocation, big_sur:        "be8d2a512b4cc468bc88fd9656b8d4d4591077b2d9523ea4e9c20039d1d761ea"
    sha256 cellar: :any_skip_relocation, catalina:       "54eac566e7bad55d5b361c92bc02d237ec8a6d1db75878d0999b511d65ed5dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5bffe22bdd226d88dea8d7cdd839c7d6f19232d9bfb9b571d0438a8aabc1c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    output = Utils.safe_popen_read(bin/"hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "fish")
    (fish_completion/"hcloud.fish").write output
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
