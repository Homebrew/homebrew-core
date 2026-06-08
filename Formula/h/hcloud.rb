class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "85a9d35760c0f694c32a7aa07eac454f48e47b8e826fef8c9d28a720b3d3a17e"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a192d01afde78bb3d8c309828511c1165ec5e99a1991e287bab6e8d172bb2162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c085888fbf9255d86525f875b22a9b3f74f4f38fb3792dd759b5aa064202788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f373ba4be60e01fde9bb6969c70e76f665b44c194218ed20e3c9f53a513fc7d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "25628a01aa050113963df09f17925730961980627223663a85e6fd7e604bff0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7196351cd68aba4762199379bb07f8eee6ebc53dea164e1796bc449b2cb024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef3f0e881ec70634b5ee11cef46902d52c01a64550107f15a3f0b8242286144"
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
