class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.70.1.tar.gz"
  sha256 "5b8f1d258a2f96d65f0fbd26ce41b35e6d529432b4bde77fc8b26245d4d01a7d"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ffc3dceaec3b13afa2084f0a891f776a59248dffe7b27b5954a09e96a98e6eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ef50c2458f6b7d3c1416ec17f0d6b1efd5c31ff66a3899a1206936e2bc51704"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef7d689c35da19fd6a2c1d6a67064dd6b7116ffaae76df283e46c8215fce2aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7009e848d5175181eae8c147f73699dc3f36b6e86e033807d52ec498f848f679"
    sha256 cellar: :any,                 x86_64_linux:      "762650aa055391dbe919825a76b055bb8efa7e7693e553b1be0ca938cf2bdc50"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
