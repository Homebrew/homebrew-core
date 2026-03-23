class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "942bd763ddce01c69efaef033a9207b3d543e068b69cb6910981ec26eb0cc434"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed2a1123adc4885eeb25b9a536062e3bf4674f6f915463563377319774d4c5f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d9e1ff61000938e267e4af27ae8849c5412240a23611f12ae1d4ac1571b0cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6f5a1eb8df2cdabe8900c127c1bd502bcdd42cbd029f1413a13f9c5bc6ca68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d229e6fc039c9ed1cbc9fb70ee63c7e05600175df765c01ee2da1f876d04d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f41a7c28b8498b914deb19c9cb710338273d48c59a1a8451453eb12c4d05fd17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "721c01a21dc3c00cfe4497d0995c6386ac9c2e24ee76339051d2741826ab377c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
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
