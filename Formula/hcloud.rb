class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.29.4.tar.gz"
  sha256 "49dab6fc46e1fa10eb49800df463f6fab413edb62b585ea9474e981d8bf98323"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb1e6b102d955da95775b4969ecf168bf5b1315e87ceea9d78edf4b9b761bb26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb00bae80cdafa1afeb1eb1b4fb913e56f52345b4218bf106ba7a6b409e52b60"
    sha256 cellar: :any_skip_relocation, monterey:       "8f748525af120ad04b7ef7cd34861c5022b4ae78ffce5f983b56d49114a52622"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9027fbbe817e0d45ef862025f42b5c293a1878b2aa9a81272ecc46707192101"
    sha256 cellar: :any_skip_relocation, catalina:       "8a009e92ca00d3e9c21fe52207847e0aa78db260684b1a5e6d5e77ab49055c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47ab1cfacc8125c9d1905ed60dc4bd288c2710f724a7d7efe09a5b1f86205c4d"
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
