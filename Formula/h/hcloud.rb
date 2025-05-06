class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "61fb1823a176ec77c102c30b3a7de50c67df7eda6dd8a3bf1f17c882e8c78011"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5926c1e2cb28a791212b47aee1fa99ef3a269b7e29325d21cd3844754e2d3053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5926c1e2cb28a791212b47aee1fa99ef3a269b7e29325d21cd3844754e2d3053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5926c1e2cb28a791212b47aee1fa99ef3a269b7e29325d21cd3844754e2d3053"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2916119cdca7afe0d62123300ac9d49649aa19e44cc14aaadfe8f55a1c86582"
    sha256 cellar: :any_skip_relocation, ventura:       "e2916119cdca7afe0d62123300ac9d49649aa19e44cc14aaadfe8f55a1c86582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3455977befd86b6dcb02de868e4d1d544134095ba3b2c74772ae1d32747b9954"
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
