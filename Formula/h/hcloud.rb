class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.64.1.tar.gz"
  sha256 "70bc7d62f4d07b408afa2eb84b0e1e5854a7f32f9defb4899f2e9a24b6846078"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "899bc8fd0ea45813092d9917de1c8e1b7edda159111f7ca8c168a6f5a97c1a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c235737977deb303c6f6fe44c5944e6182923c102d81fdeb55c25d3a3022db04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "278888beef0e55ec37db9ef866e12b5787be7af5ff5a1ae50798751428133a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2589447229bce753786122508747213bab3a6ecc6bc1763c82bb62cbcb75590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb0bfc4769fdc8838ecbb198d0c79908fe37048a0b857c3c3cf356e28dd98adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b6314d35d7bfc44515bc0c41a4f873ed9271f1a8f6cbe76702a242d4a98d3c0"
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
