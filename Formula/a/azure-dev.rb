class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.24.1.tar.gz"
  sha256 "f6c848c3fb6e4dda45ef00ba45c901b60ad92e2b12c976b7c3c0dbc7465c70ed"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0223df4505d28b9142d5f246af2e46cb452fb60dda473a0b2b58bbac23c24df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0223df4505d28b9142d5f246af2e46cb452fb60dda473a0b2b58bbac23c24df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0223df4505d28b9142d5f246af2e46cb452fb60dda473a0b2b58bbac23c24df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "595c0188f9444067b955e07d5330276ce8639b7990b97217b0b47f63e0d248e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "857a46e7ecdceb3eee72d19654b7c05f9d9192e365111f4297bc05f378224b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87999ae28d087504d6ff8c48da38ce5be2167ddaa3b8b5e070dfb86972b0ae14"
  end

  depends_on "go" => :build

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
    ldflags = %W[
      -s -w
      -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"
    ]
    system "go", "build", "-C", "cli/azd", *std_go_args(ldflags:, output: bin/"azd")

    generate_completions_from_executable(bin/"azd", shell_parameter_format: :cobra)
  end

  test do
    ENV["AZURE_DEV_COLLECT_TELEMETRY"] = "no"
    ENV["AZD_DISABLE_PROMPTS"] = "1"
    ENV["AZD_CONFIG_DIR"] = (testpath/"config").to_s

    assert_match version.to_s, shell_output("#{bin}/azd version")

    system bin/"azd", "config", "set", "defaults.location", "eastus"
    assert_match "eastus", shell_output("#{bin}/azd config get defaults.location")

    expected = "Not logged in, run `azd auth login` to login to Azure"
    assert_match expected, shell_output("#{bin}/azd auth login --check-status")
  end
end
