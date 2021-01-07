class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.20.0.tar.gz"
  sha256 "116089f671f3f484b45fa8264cd016f92246421ba8c444a98d5bc18741e625e5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2430a366d43eb83d64cad15d49681918dcda9a46300a8bf9ac8c23f9fb00eb98" => :big_sur
    sha256 "d2e742678a740e0dca5905278073f4118e36ab88f386b38088676df62597e5d6" => :arm64_big_sur
    sha256 "eae32494202f0802d016674a7d7d88ed835fe3c53736a4e95aac5071fcdebc76" => :catalina
    sha256 "0a2006376bae1e28cc3f6f1254aa78a43ff5206423b61720f87770b55c903375" => :mojave
    sha256 "0b4c72eaeac1f22e2e6a54004ef963a7f90c1cecdb681c09d82238abf9725261" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/cli.Version=v#{version}"
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
