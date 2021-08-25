class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.28.0.tar.gz"
  sha256 "1e12d771d44b3c25c2b6d96a56465cd3712ec557f5059bad59741108f48f8b3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f61671545385598f8d9e8f069f708c3a855ab0b4b22c8aece6ed2151623f28f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c1d4840a1a211664685999b99653c7ae00005926fc08c88239053ec9d8e63b6"
    sha256 cellar: :any_skip_relocation, catalina:      "8d7a8f748575f9dfd0607a12d68afd6ae62ca6e376293b7d921f07202d074b59"
    sha256 cellar: :any_skip_relocation, mojave:        "883144bbecba98fbd2418f394ffc3b425f86599482ce619271301ca483b8c023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda3b5c6e7c941fbc579aa57dcd01e486ee564062e1613aba39c8ff83d06e0aa"
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
