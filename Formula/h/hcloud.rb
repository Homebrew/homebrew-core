class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "530b5925a93da73b7f346e61ff7f8742fae400cd6dfaa1374963b1adbe594138"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7827e1af3e21d91e64cd6b32a2aaf2b9a4700a79f093dae9205e24e848fd01dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45d2ce8910e71a300e2c06f9a5c01765529c9f2b37ef6eb9c460eac9e116c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "545f332f681b5de55df7f283a78d15f5ff36eee338752ad624ceff7d0f58983e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b53acd81bae9ca4f1027e1a3311479be55bf060759e39be69dcf4913496ff3b"
    sha256 cellar: :any_skip_relocation, ventura:       "ebded319b8048793fba63fd83f9e67fc2d3284e41f94fb2cea4c253891f6b8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f680fafab6d685802e526beb06d26d585f2d85b3e03ce246d679c27639275b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

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
