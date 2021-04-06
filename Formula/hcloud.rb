class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.22.1.tar.gz"
  sha256 "6b43ad74ec243484c7c1dd1d7cb2d6f1231f596a2ea4753bf81087f5b8dcf1c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bd489ae440e8c7ab24d09258ea87adf826b7c4c0f2a0fed59615d8a4a18fce9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a5a8f726f44890f50b6170881762e0ccaf37af5ba68c4edc79c15e44938e5f1"
    sha256 cellar: :any_skip_relocation, catalina:      "759da05c17ed97cb3c37ff5fafaca48a96b124257d8a18faadb35a194c880126"
    sha256 cellar: :any_skip_relocation, mojave:        "fcff19cd0ef01350b9f51ba62892cf988cbea543a662aa95972dd1487f3853c7"
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
