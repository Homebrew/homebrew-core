class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.63.0.tar.gz"
  sha256 "bdc265fdf5c514681a2859e80494b11f2b6e64a5a5f0a52236a0ec6c153ce86a"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9fb4c37e6e5eaab853372621376992b542592af799ed39832dfd0deac25200f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91a7d63fac15e0bb5185a4a17ca00b3751c9b161ab238ae6a96c4a6fced1d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70883c0060d374a1e15f3cac187c968bbe2cb8e30cc7b09d7f70fad55ee10c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f108f633b531716ed5fc05c913876c89238eebfa55bd706c416f4371b9229c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135aa0f7a18e976ea8617d7ced9568e670d4e0bed2201f3a4319596314d97815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726b375f5700c5e1fa762aee4663dd5565ce2fde2b082a12fffdc09021de1e2f"
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
