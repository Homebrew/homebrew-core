class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.28.1.tar.gz"
  sha256 "fef9763ffe17668c8f434f27d99050b425039fb0d93d8d3a31ea55f99cfbad11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90bc10a1d8be2dea82e5c232f993b97a225d0ee2e1cc726440b1763ac0104964"
    sha256 cellar: :any_skip_relocation, big_sur:       "45d843d3e4e33d9fada23ecbe18d68863f5c01b03010d3518891b0d89cf0de55"
    sha256 cellar: :any_skip_relocation, catalina:      "2d6b8e61a09f91da90fbc2bb6b629792db38cd4b515b7804ba8adebaf8ecc4e3"
    sha256 cellar: :any_skip_relocation, mojave:        "4b67d26abb3c2a497eb4a14826a371f728b04bc2a4754c36221d2f50cbeca713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3913db2d75c42cbc2e20df6c790015e23c49b0cb169e1f221a93ec346973c1ab"
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
