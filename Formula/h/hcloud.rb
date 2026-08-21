class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "e3e0f58c1e893ac1848ec749308ea08f49cf692c6e04762b55f0df73b633cd2c"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eb8da390af6ae7079579a487ba7564ff32ff471d919c1c7ae47e853a1dc66cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0856455c3d999394def2b96d11fe7a16c0ef937b500c1e75cc874d2bb2df4f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f460b5dbbc75b9b0d9485bbc11a299cd2b28b5da18e981546ec9bbf440e43f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd40ccf960de97bd692d7ca2d523bd91a7f0355062bb53b3b857ab25bd5e700c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2496bfd05d4074b443938d78423fb679f3ef860ce9b746a766d723410ccc5dde"
    sha256 cellar: :any,                 x86_64_linux:  "728679684522e708c67612c51d2f363d02c87338a2da5321a510520beb1ea8f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
