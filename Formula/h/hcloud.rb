class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "fa2eec8723d69e27f4300475dac34c9ee240c39366134c36f3c669032b37b9b3"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    manifest_sha256 "19657c9dde47d33cfe6915a76576f60fa29f62f82c37f9bdbf5b981b61214744"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb11155326609b2eb85c32b5457bbaaebf6dfc17e59dcd10e8976e4eed5f9389"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d64f6c47bb1f61a6437c44bcc3d18e6148a3d12b64bf95b7a7562fc210b476c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "581693ca986a15005c432155ed91137c7d76dbeb857157382fb68c15edfab02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd5eea54f2f143dd3124cf05fefd99ea18ed5ae3bf96499649847934faffbc36"
    sha256 cellar: :any,                 x86_64_linux:      "9ace960a8cf4afd1a3f87aeecb98e424cf1db1dda083101e3264aa21764d07a0"
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
