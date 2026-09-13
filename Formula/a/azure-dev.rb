class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.34.0.tar.gz"
  sha256 "8d53317656216cfb61444a62de75c02e031240f6ce0b749542031e75edd06447"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a5164224530a481caa91700eb841911a744f3bb7c3633a45805a9f909c8de7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a5164224530a481caa91700eb841911a744f3bb7c3633a45805a9f909c8de7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a5164224530a481caa91700eb841911a744f3bb7c3633a45805a9f909c8de7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1a5164224530a481caa91700eb841911a744f3bb7c3633a45805a9f909c8de7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b37876ddcde7a65b5927a7857d477a16bee322a4b1d50580adeda3b5a63f6c1e"
    sha256 cellar: :any,                 x86_64_linux:      "a48f5516f033caa1f27a4451399cfe944dc61355ab565a57304b60588fe4e772"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cli/azd"
  end

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = if build.stable?
      "#{version} (commit 0000000000000000000000000000000000000000)"
    else
      "#{File.read("cli/version.txt").strip} (commit #{Utils.git_head})"
    end
    ldflags = %W[-X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"]
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
