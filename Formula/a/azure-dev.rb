class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.24.2.tar.gz"
  sha256 "364c9353b5e326debdc8dbff4a93c7a5f61c5aac73927b5085842e90b8180fd6"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d1a5576a4adf20eaf8764abf8053ca87757c07fc7bfbfd361055abba95ddd9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1a5576a4adf20eaf8764abf8053ca87757c07fc7bfbfd361055abba95ddd9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d1a5576a4adf20eaf8764abf8053ca87757c07fc7bfbfd361055abba95ddd9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2083eaf155c354b82951e3779a3c4395e619b1bea7de09a13bb59b2c2211a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2074bb359c263c0d640c5c51d5d1908e007be30324ef245eaa1b368395ab778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e495e59ae8f34108ed6fdfd84c587469c72c0c3523c132c68e90114a93299cdc"
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
