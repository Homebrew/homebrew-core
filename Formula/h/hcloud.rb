class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "e99b116586d8040f33994bb1ef232b7def058fcd43f24abd3db22e822da11419"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d6f30a931983997ef14b383558216328b786b64eec64d11fa1248bca2c70742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca3416fdeadd625d4655b08e0e8ae5436f01910c8ebcab9ec755f45eac63c58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8a3496527433273f3c9505319aef57bf99595094a3424853d8ae3b275c39094"
    sha256 cellar: :any_skip_relocation, sonoma:        "58471d520acb9f6854a3cf0e1e90cdb38085493b4b5429c54bb4e0a9549a3f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72dfad8b325798ee9e47b7a53a157bba678073b1c669128855a7670b9daa7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef8841a8741b1736526db75fb1e52ff14cb31afc7a5cdac2a57d96ef6cb2e93"
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
