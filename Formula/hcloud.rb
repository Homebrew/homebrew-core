class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.26.1.tar.gz"
  sha256 "ba7fed423b2c437adfb4b98b2fdadaad6b6325f8e31cac2729982b7bf2523c81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb0d4214db32a5aca9cdd4ad95e0d8bb366dd63bcb3eee3e27808004bd7a7c6d"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa9f59c8e2352adf1966a35331c474012920edfc06f06ccabd1b4e743ecaa0c1"
    sha256 cellar: :any_skip_relocation, catalina:      "1a05ab868a63ccc3f79aeaefad9d8a807c014983830a0b7f801d36caa3972c32"
    sha256 cellar: :any_skip_relocation, mojave:        "960ce57d6558bb94ce65d134643a22358f23de6e955b8a78da42dbd427ddf040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061e0258e203b2dc93e1222c1449d7f92681405441719ca3c28344b6349b7e0a"
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
