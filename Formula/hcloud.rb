class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.33.1.tar.gz"
  sha256 "bbd337684b51ecd6848f6b7531f3a2793c43d0fbe2ece13f153ce1504a1e72f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db0a0abf71040f9fd5de8b8adca8f977dc2821de5123b5b3490b4c62dc008384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db0a0abf71040f9fd5de8b8adca8f977dc2821de5123b5b3490b4c62dc008384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db0a0abf71040f9fd5de8b8adca8f977dc2821de5123b5b3490b4c62dc008384"
    sha256 cellar: :any_skip_relocation, ventura:        "ede762181f0f1edba305d2a37e88b1f71adad96c05cc16477b3f2df3c9116939"
    sha256 cellar: :any_skip_relocation, monterey:       "ede762181f0f1edba305d2a37e88b1f71adad96c05cc16477b3f2df3c9116939"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede762181f0f1edba305d2a37e88b1f71adad96c05cc16477b3f2df3c9116939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbc4178cac8354519220692c9f5c6715f90144c98b6b63a4f22b0205fa5d58b"
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
