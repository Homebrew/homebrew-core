class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.29.0.tar.gz"
  sha256 "ea8b08702f7285d5e886fc8797287ac05747eb66ad1d77d041725f9cf6c88893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79975ec7cae0e341e3e68bcae0f34e73b1c08578b891ce9c052caa97817c6d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55dea4dedf70a947328f032378382696bee99402aa7960f9b4263f7832b02d8e"
    sha256 cellar: :any_skip_relocation, monterey:       "729ddc1b3d05e78bc7bf0a460bd10aac526a4eea91e189fbe4f43d0cf22a1160"
    sha256 cellar: :any_skip_relocation, big_sur:        "4881505b15262f94e03e1915eed4afc3b56a13c545232aedc4f0df027d147b11"
    sha256 cellar: :any_skip_relocation, catalina:       "483a968880a61408fc96bc5c6743f5a246086f2b8da6a08060b0770dd598fcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac78af46935063cf486ca697346ad9c8612da8025286d20c39886948d59ec084"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

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
