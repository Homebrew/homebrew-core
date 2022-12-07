class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.31.1.tar.gz"
  sha256 "d9ee39db85eb2f0ff5f812331c674f32ceab6f1203f5d14be2f732a555f12795"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f38c00d158410f4b8d71f687235d7ce6808fda33000305efd51bd943fd9d0c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08619f372c12b424a72ccaeef4605e9edcb0d786cbdab2c14523ebd86675c1fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "665580bf74cdabb604f389f23c06e43d9b5422a2307854ee83b21c93bec7ebf0"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3c75ceb0b89313d6a48db4a6cf633d712b014c847e5aeb5ed8fe3ccc87f4fa"
    sha256 cellar: :any_skip_relocation, monterey:       "ffde5c437f729a383601f2a750d31cf62cbef9845004029302ba0c55b888c93c"
    sha256 cellar: :any_skip_relocation, big_sur:        "833103cf9af9740352c433698399f0272594a78961c65b77b6a7157eb564c383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29c6db00c30032dbe3fc8588eccc6f9c46650a8068224885183fc014368b499a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
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
